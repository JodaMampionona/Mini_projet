from app.dao.DAO_interface import DAOInterface
from app.db.db_helper import DBHelper
from app.model.bus_stop_model import BusStop


class BusStopDAO(DAOInterface):
    def __init__(self):
        self.helper = DBHelper()

    def get_all(self):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute("SELECT id, name, lat, lon FROM bus_stops;")
            rows = cursor.fetchall()
            return [BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3]) for row in rows]

    def get_by_id(self, stop_id: int):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute(
                "SELECT id, name, lat, lon FROM bus_stops WHERE id=%s;", (stop_id,))
            row = cursor.fetchone()
            return BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3]) if row else None

    def get_by_ids(self, ids: list):
        if len(ids) == 0:
            return []
        with self.helper.get_connection().cursor() as cursor:
            format_strings = ','.join(['%s'] * len(ids))
            cursor.execute(
                f"SELECT id, name, lat, lon FROM bus_stops WHERE id IN ({format_strings});", tuple(ids))
            rows = cursor.fetchall()
            return [BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3]) for row in rows]

    def get_first_stop(self, bus_id: int):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute(
                "SELECT bs.id, bs.name, bs.lat, bs.lon FROM bus_stops bs JOIN bus_stop_links bsl ON bs.id = bsl.stop_id WHERE bsl.bus_id = %s AND bsl.rank = 1;",
                (bus_id,))
            row = cursor.fetchone()
            return BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3]) if row else None

    def get_last_stop(self, bus_id: int):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute(
                "SELECT bs.id, bs.name, bs.lat, bs.lon FROM bus_stops bs JOIN bus_stop_links bsl ON bs.id = bsl.stop_id WHERE bsl.bus_id = %s ORDER BY bsl.rank DESC LIMIT 1;",
                (bus_id,))
            row = cursor.fetchone()
            return BusStop(id=row[0], name=row[1], lat=row[2], lon=row[3]) if row else None


    # TODO: do not insert ID
    def add(self, stop: BusStop):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO bus_stops (id, name, lat, lon) VALUES (%s, %s, %s, %s) RETURNING id;",
                (stop.id, stop.name, stop.lat, stop.lon)
            )
            stop.id = cursor.fetchone()[0]
        conn.commit()
        return stop

    def update(self, stop: BusStop):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE bus_stops SET name=%s, lat=%s, lon=%s WHERE id=%s;",
                (stop.name, stop.lat, stop.lon, stop.id)
            )
        conn.commit()

    def delete(self, stop_id: int):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM bus_stops WHERE id=%s;", (stop_id,))
        conn.commit()
