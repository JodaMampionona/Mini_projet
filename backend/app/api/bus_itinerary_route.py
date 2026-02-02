from fastapi import APIRouter, HTTPException
from app.service.bus_itinerary_service import BusItineraryService

router = APIRouter()
service = BusItineraryService()


@router.get("/")
def get_bus_itinerary(start_id: int, destination_id: int):
    return service.get_bus_itinerary(start_id, destination_id)

# ✅ NOUVEL endpoint GPS
@router.get("/gps")
def get_bus_itinerary_by_gps(
    start_lat: float,
    start_lon: float,
    end_lat: float,
    end_lon: float
):
    return service.get_bus_itinerary_by_gps(
        start_lat, start_lon, end_lat, end_lon
    )