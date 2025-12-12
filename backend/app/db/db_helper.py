import os
import psycopg2
from pathlib import Path
from dotenv import load_dotenv
from app.entities.bus_entity import BusEntity


env_path = Path(__file__).resolve().parent.parent.parent / ".env"
load_dotenv(dotenv_path=env_path)


class DBHelper:
    _instance = None

    # singleton db_helper
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._connection = None
            cls._instance._dsn = {
                "dbname": os.getenv("DB_NAME"),
                "user": os.getenv("DB_USER"),
                "password": os.getenv("DB_PASSWORD"),
                "host": os.getenv("DB_HOST"),
                "port": os.getenv("DB_PORT")
            }
        return cls._instance

    def get_connection(self):
        if self._connection is None or self._connection.closed:
            self._connection = psycopg2.connect(**self._dsn)
        return self._connection

    def close_connection(self):
        if self._connection and not self._connection.closed:
            self._connection.close()
            self._connection = None
