from app.repository.bus_repository import BusRepository
from app.repository.bus_stop_repository import BusStopRepository
from app.repository.bus_stop_link_repository import BusStopLinkRepository

class BusService:
    def __init__(self):
        self.busRepo = BusRepository()
        self.stopRepo = BusStopRepository()
        self.linkRepo = BusStopLinkRepository()

    def get_buses_simple_list(self):
        buses = self.busRepo.get_all()

        return [{"id": b.id, "name": b.name, "itinerary": [
            self.stopRepo.get_first_stop(b.id),
            self.stopRepo.get_last_stop(b.id)
        ]} for b in buses]

    def get_bus_details_with_stops(self, bus_id: int):
        """Retourne les détails d'un bus et son itinéraire complet (tous les arrêts)."""
        bus = self.busRepo.get_by_id(bus_id)
        if not bus:
            return None

        all_links = self.linkRepo.get_links_ordered_by_rank()
        bus_links = [link for link in all_links if link.bus.id == bus_id]

        stops_itinerary = []
        for link in bus_links:
            stops_itinerary.append({
                "id": link.stop.id,
                "name": link.stop.name,
                "lat": link.stop.lat,
                "lon": link.stop.lon,
                "rank": link.rank
            })

        return {
            "id": bus.id,
            "name": bus.name,
            "itinerary": stops_itinerary
        }
