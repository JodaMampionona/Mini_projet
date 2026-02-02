from fastapi import APIRouter, HTTPException
from app.service.bus_itinerary_service import BusItineraryService

router = APIRouter()
service = BusItineraryService()


@router.get("/")
def get_bus_itinerary(start_lat: float, start_lon: float, destination_lat: float, destination_lon: float):
    return service.get_bus_itinerary(start_lat, start_lon, destination_lat, destination_lon)
