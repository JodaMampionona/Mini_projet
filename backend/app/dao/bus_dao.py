from app.dao.DAO_interface import DAOInterface
from app.db.db_helper import DBHelper
from app.model.bus_model import Bus


class BusDAO(DAOInterface):
    def __init__(self):
        self.helper = DBHelper()

    def get_all(self):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute("SELECT id, name FROM buses;")
            rows = cursor.fetchall()
            return [Bus(id=row[0], name=row[1]) for row in rows]

    def get_by_id(self, bus_id: int):
        with self.helper.get_connection().cursor() as cursor:
            cursor.execute(
                "SELECT id, name FROM buses WHERE id=%s;", (bus_id,))
            row = cursor.fetchone()
            return Bus(id=row[0], name=row[1]) if row else None

    def get_by_ids(self, ids: list):
        if len(ids) == 0:
            return []
        with self.helper.get_connection().cursor() as cursor:
            format_strings = ','.join(['%s'] * len(ids))
            cursor.execute(
                f"SELECT id, name FROM buses WHERE id IN ({format_strings});", tuple(ids))
            rows = cursor.fetchall()
            return [Bus(id=row[0], name=row[1]) for row in rows]

    # TODO: do not insert ID
    def add(self, bus: Bus):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO buses (id, name) VALUES (%s, %s) RETURNING id;",
                (bus.id, bus.name,)
            )
            bus.id = cursor.fetchone()[0]
        conn.commit()
        return bus

    def update(self, bus: Bus):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE buses SET name=%s WHERE id=%s;",
                (bus.name, bus.id)
            )
        conn.commit()

    def delete(self, bus_id: int):
        conn = self.helper.get_connection()
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM buses WHERE id=%s;", (bus_id,))
        conn.commit()
