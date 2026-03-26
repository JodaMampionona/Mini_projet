from app.dao.DAO_interface import DAOInterface
from app.db.db_helper import DBHelper
from app.model.bus_stop_model import BusStop
from app.model.bus_model import Bus


class BusStopDAO(DAOInterface):
    def __init__(self):
        self.helper = DBHelper()

    def get_buses_for_stop(self, stop_id: int):
        """Récupère tous les bus qui passent par un arrêt donné."""
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute("""
                SELECT b.id, b.name
                FROM buses b
                JOIN bus_stop_links bsl ON b.id = bsl.bus_id
                WHERE bsl.stop_id = %s
                ORDER BY b.id;
            """, (stop_id,))
            rows = cursor.fetchall()
            return [Bus(id=row[0], name=row[1]) for row in rows]

    def get_all(self):
        with self.helper.get_connection().cursor() as cursor:
            """ TODO : order by zone ? """
            cursor.execute("SELECT id, name, lat, lon, zone FROM bus_stops ORDER BY zone;")
            rows = cursor.fetchall()
            bus_stops = []
            for row in rows:
                stop = BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3], zone=row[4])
                stop.bus = self.get_buses_for_stop(stop.id)
                bus_stops.append(stop)
            return bus_stops

    def get_all_paginated(self, page: int, page_size: int):
        offset = (page - 1) * page_size
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute(
                "SELECT id, name, lat, lon, zone FROM bus_stops ORDER BY id LIMIT %s OFFSET %s;",
                (page_size, offset)
            )
            rows = cursor.fetchall()
            bus_stops = []
            for row in rows:
                stop = BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3], zone=row[4])
                stop.bus = self.get_buses_for_stop(stop.id)
                bus_stops.append(stop)
            return bus_stops

    def get_total_count(self):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute("SELECT COUNT(*) FROM bus_stops;")
            return cursor.fetchone()[0]

    def get_by_id(self, stop_id: int):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute(
                "SELECT id, name, lat, lon, zone FROM bus_stops WHERE id=%s;", (stop_id,))
            row = cursor.fetchone()
            if row:
                stop = BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3], zone=row[4])
                stop.bus = self.get_buses_for_stop(stop.id)
                return stop
            return None

    def get_by_ids(self, ids: list):
        if len(ids) == 0:
            return []
        with self.helper.get_connection().cursor() as cursor:
            format_strings = ','.join(['%s'] * len(ids))
            cursor.execute(
                f"SELECT id, name, lat, lon, zone FROM bus_stops WHERE id IN ({format_strings});", tuple(ids))
            rows = cursor.fetchall()
            bus_stops = []
            for row in rows:
                stop = BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3], zone=row[4])
                stop.bus = self.get_buses_for_stop(stop.id)
                bus_stops.append(stop)
            return bus_stops

    def get_first_stop(self, bus_id: int):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute(
                "SELECT bs.id, bs.name, bs.lat, bs.lon, bs.zone FROM bus_stops bs JOIN bus_stop_links bsl ON bs.id = bsl.stop_id WHERE bsl.bus_id = %s AND bsl.rank = 1;",
                (bus_id,))
            row = cursor.fetchone()
            if row:
                stop = BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3], zone=row[4])
                stop.bus = self.get_buses_for_stop(stop.id)
                return stop
            return None

    def get_last_stop(self, bus_id: int):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute(
                "SELECT bs.id, bs.name, bs.lat, bs.lon, bs.zone FROM bus_stops bs JOIN bus_stop_links bsl ON bs.id = bsl.stop_id WHERE bsl.bus_id = %s ORDER BY bsl.rank DESC LIMIT 1;",
                (bus_id,))
            row = cursor.fetchone()
            if row:
                stop = BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3], zone=row[4])
                stop.bus = self.get_buses_for_stop(stop.id)
                return stop
            return None

    def search(self, query: str):
        """Cherche les arrêts par zone ou nom."""
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute("""
                SELECT id, name, lat, lon, zone FROM bus_stops
                WHERE zone ILIKE %s OR name ILIKE %s
                ORDER BY zone, name;
            """, (f"%{query}%", f"%{query}%"))
            rows = cursor.fetchall()
            bus_stops = []
            for row in rows:
                stop = BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3], zone=row[4])
                stop.bus = self.get_buses_for_stop(stop.id)
                bus_stops.append(stop)
            return bus_stops

    # TODO: do not insert ID
    def add(self, stop: BusStop):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO bus_stops (id, name, lat, lon, zone) VALUES (%s, %s, %s, %s, %s) RETURNING id;",
                (stop.id, stop.name, stop.lat, stop.lon, stop.zone)
            )
            stop.id = cursor.fetchone()[0]
        conn.commit()
        return stop

    def update(self, stop: BusStop):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE bus_stops SET name=%s, lat=%s, lon=%s, zone=%s WHERE id=%s;",
                (stop.name, stop.lat, stop.lon, stop.zone, stop.id)
            )
        conn.commit()

    def delete(self, stop_id: int):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM bus_stops WHERE id=%s;", (stop_id,))
        conn.commit()

