from app.dao.bus_stop_dao import BusStopDAO
from app.model.bus_stop_model import BusStop

class BusStopRepository:
    def __init__(self):
        self.dao = BusStopDAO()

    def get_all(self): return self.dao.get_all()

    def get_by_id(self, stop_id: int): return self.dao.get_by_id(stop_id)

    def get_by_ids(self, ids: list): return self.dao.get_by_ids(ids)

    def add(self, stop: BusStop): return self.dao.add(stop)

    def update(self, stop: BusStop): return self.dao.update(stop)

    def delete(self, stop_id: int): return self.dao.delete(stop_id)