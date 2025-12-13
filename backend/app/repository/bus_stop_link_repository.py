from app.dao.bus_stop_link_dao import BusStopLinkDAO
from app.model.bus_stop_link_model import BusStopLink
from app.model.bus_model import Bus
from app.model.bus_stop_model import BusStop

class BusStopLinkRepository:
    def __init__(self):
        self.dao = BusStopLinkDAO()

    def get_all(self): return self.dao.get_all()

    def get_links_ordered_by_rank(self): return self.dao.get_links_ordered_by_rank()

    def get_by_id(self, bus_stop_link_id: int): return self.dao.get_by_id(bus_stop_link_id)
    
    def get_by_ids(self, ids: list): return self.dao.get_by_ids(ids)

    def add(self, link: BusStopLink): return self.dao.add(link)

    def update(self, link: BusStopLink): return self.dao.update(link)

    def delete(self, bus_stop_link_id: int): return self.dao.delete(bus_stop_link_id)