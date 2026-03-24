from app.repository.bus_stop_repository import BusStopRepository

class BusStopsService:
    def __init__(self):
        self.busStopRepo = BusStopRepository()

    def get_all(self):
        return self.busStopRepo.get_all()

    def get_all_paginated(self, page: int, page_size: int):
        stops = self.busStopRepo.get_all_paginated(page, page_size)
        total = self.busStopRepo.get_total_count()
        total_pages = (total + page_size - 1) // page_size
        
        return {
            "data": stops,
            "pagination": {
                "page": page,
                "page_size": page_size,
                "total": total,
                "total_pages": total_pages
            }
        }