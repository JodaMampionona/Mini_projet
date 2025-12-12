from app.repository.bus_stop_repository import BusStopRepository

class BusStopsService:
    def __init__(self):
        self.busStopRepo = BusStopRepository()

    def get_all(self):
        return self.busStopRepo.get_all()