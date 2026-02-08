from app.service.bus_stops_service import BusStopsService
from fastapi import APIRouter

router = APIRouter()
service = BusStopsService()

@router.get("/")
def get_all_bus_stops():
    return service.get_all()

