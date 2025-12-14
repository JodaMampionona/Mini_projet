from app.dao.DAO_interface import DAOInterface
from app.db.db_helper import DBHelper
from app.model.bus_model import Bus
from app.model.bus_stop_model import BusStop
from app.model.bus_stop_link_model import BusStopLink


class BusStopLinkDAO(DAOInterface):
    def __init__(self):
        self.helper = DBHelper()

    def get_all(self):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute("""
                SELECT b.id, b.name, s.id, s.name, s.lat, s.lon, bsl.rank
                FROM bus_stop_links bsl
                JOIN buses b ON bsl.bus_id = b.id
                JOIN bus_stops s ON bsl.stop_id = s.id;
            """)
            rows = cursor.fetchall()
            return [
                BusStopLink(
                    bus=Bus(id=row[0], name=row[1]),
                    stop=BusStop(
                        id=row[2], name=row[3], lat=row[4], lon=row[5]),
                    rank=row[6]
                )
                for row in rows
            ]

    def get_links_ordered_by_rank(self):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute("""
                SELECT s.id, s.name, s.lat, s.lon, b.id, b.name, links.rank
                FROM bus_stop_links links
                JOIN bus_stops s ON links.stop_id = s.id
                JOIN buses b ON links.bus_id = b.id
                ORDER BY links.rank;
            """)
            rows = cursor.fetchall()
            return [
                BusStopLink(
                    stop=BusStop(
                        id=row[0], name=row[1], lat=row[2], lon=row[3]),
                    bus=Bus(id=row[4], name=row[5]),
                    rank=row[6]
                )
                for row in rows
            ]

    def get_by_id(self, bus_stop_link_id: int):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute("""
                SELECT b.id, b.name, s.id, s.name, s.lat, s.lon, bsl.rank
                FROM bus_stop_links bsl
                JOIN buses b ON bsl.bus_id = b.id
                JOIN bus_stops s ON bsl.stop_id = s.id
                WHERE bsl.id=%s;
            """, (bus_stop_link_id,))
            row = cursor.fetchone()
            return BusStopLink(
                bus=Bus(id=row[0], name=row[1]),
                stop=BusStop(
                    id=row[2], name=row[3], lat=row[4], lon=row[5]),
                rank=row[6]
            ) if row else None

    def get_by_ids(self, ids: list):
        if len(ids) == 0:
            return []
        with self.helper.get_connection().cursor() as cursor:
            format_strings = ','.join(['%s'] * len(ids))
            cursor.execute("""
                SELECT b.id, b.name, s.id, s.name, s.lat, s.lon, bsl.rank
                FROM bus_stop_links bsl
                JOIN buses b ON bsl.bus_id = b.id
                JOIN bus_stops s ON bsl.stop_id = s.id
                WHERE bsl.id IN ({format_strings});
            """, (tuple(ids),))
            rows = cursor.fetchall()
            return BusStopLink(
                bus=Bus(id=row[0], name=row[1]),
                stop=BusStop(
                    id=row[2], name=row[3], lat=row[4], lon=row[5]),
                rank=row[6]
            ) if row else None

    # TODO: do not insert ID
    def add(self, link: BusStopLink):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute(
                'INSERT INTO bus_stop_links (id, bus_id, stop_id, rank) VALUES (%s, %s, %s, %s);',
                (link.id, link.bus.id, link.stop.id, link.rank)
            )
        conn.commit()
        return link

    def update(self, link: BusStopLink):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute(
                'UPDATE bus_stop_links SET rank=%s WHERE bus_id=%s AND stop_id=%s;',
                (link.rank, link.bus.id, link.stop.id)
            )
        conn.commit()

    def delete(self, bus_stop_link_id: int):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute(
                'DELETE FROM bus_stop_links WHERE id=%s;',
                (bus_stop_link_id,)
            )
        conn.commit()
