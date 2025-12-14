from app.repository.bus_stop_link_repository import BusStopLinkRepository

class BusStopLinksService:
    def __init__(self):
        self.linkRepo = BusStopLinkRepository()

    def get_all(self):
        return self.linkRepo.get_all()