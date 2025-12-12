from fastapi import APIRouter, HTTPException
from app.service.bus_itinerary_service import BusItineraryService

router = APIRouter()
service = BusItineraryService()


@router.get("/")
def get_bus_itinerary(start: str, destination: str):
    itinerary = service.get_bus_itinerary(start, destination)
    return {"itinerary": itinerary}
