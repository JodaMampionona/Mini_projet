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
        dest_lat=destination_lat,
        dest_lon=destination_lon
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
def search_stops(q: Optional[str] = Query(None, description="Le nom du lieu à rechercher"), lat: Optional[float] = Query(None), lon: Optional[float] = Query(None)):
    if q is not None:
        result = service.search_nearby_stops_by_name(q)
    elif lat is not None and lon is not None:
        result = service.search_nearby_stops_by_lat_lon(lat, lon)
    else:
        raise HTTPException(
            status_code=400, detail="Fournir soit 'q' soit 'lat' et 'lon'")

    if "error" in result:
        raise HTTPException(status_code=404, detail=result["error"])
    return result
