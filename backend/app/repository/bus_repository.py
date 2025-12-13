from app.dao.bus_dao import BusDAO
from app.model.bus_model import Bus

class BusRepository:

    def __init__(self):
        self.dao = BusDAO()
    
    def get_all(self): return self.dao.get_all()

    def get_by_id(self, bus_id: int): return self.dao.get_by_id(bus_id)

    def get_by_ids(self, ids: list): return self.dao.get_by_ids(ids)

    def add(self, bus: Bus): return self.dao.add(bus)

    def update(self, bus: Bus): return self.dao.update(bus)

    def delete(self, bus_id: int): return self.dao.delete(bus_id)
