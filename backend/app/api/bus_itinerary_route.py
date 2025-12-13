from fastapi import APIRouter, HTTPException
from app.service.bus_itinerary_service import BusItineraryService

router = APIRouter()
service = BusItineraryService()


@router.get("/")
def get_bus_itinerary(start_id: int, destination_id: int):
    return service.get_bus_itinerary(start_id, destination_id)
