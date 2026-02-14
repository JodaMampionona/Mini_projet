from fastapi import APIRouter, HTTPException, Query
from typing import Optional
from app.service.bus_itinerary_service import BusItineraryService

router = APIRouter()
service = BusItineraryService()


@router.get("/")
def get_bus_itinerary_by_gps(start_lat: float, start_lon: float, destination_lat: float, destination_lon: float):
    return service.get_bus_itinerary_by_gps(
        start_lat=start_lat,
        start_lon=start_lon,
        destination_lat=destination_lat,
        destination_lon=destination_lon
    )
# endpoint pour /bus et /bus/?bus_id
@router.get("/bus")
def get_buses(bus_id: Optional[int] = Query(None)):
    if bus_id is not None:
        bus_details = service.get_bus_details_with_stops(bus_id)
        if not bus_details:
            raise HTTPException(status_code=404, detail="Bus non trouvé")
        return bus_details
    return service.get_buses_simple_list()

@router.get("/search")
def search_stops(q: str = Query(..., description="Le nom du lieu à rechercher")):
    result = service.search_nearby_stops(q)
    if "error" in result:
        raise HTTPException(status_code=404, detail=result["error"])
    return result

