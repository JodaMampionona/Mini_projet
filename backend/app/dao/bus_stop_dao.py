from app.dao.DAO_interface import DAOInterface
from app.db.db_helper import DBHelper
from app.entities.bus_stop_entity import BusStopEntity


class BusStopDAO(DAOInterface):
    def __init__(self):
        self.helper = DBHelper()

    def get_all(self):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute("SELECT id, name, lat, lon FROM bus_stops;")
            rows = cursor.fetchall()
            return [BusStopEntity(id=row[0], name=row[1], lat=row[2], lon=row[3]) for row in rows]

    def get_by_id(self, stop_id: int):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute(
                "SELECT id, name, lat, lon FROM bus_stops WHERE id=%s;", (stop_id,))
            row = cursor.fetchone()
            return BusStopEntity(id=row[0], name=row[1], lat=row[2], lon=row[3]) if row else None

    # TODO: do not insert ID
    def add(self, stop: BusStopEntity):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO bus_stops (id, name, lat, lon) VALUES (%s, %s, %s, %s) RETURNING id;",
                (stop.id, stop.name, stop.lat, stop.lon)
            )
            stop.id = cursor.fetchone()[0]
        conn.commit()
        return stop

    def update(self, stop: BusStopEntity):
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
