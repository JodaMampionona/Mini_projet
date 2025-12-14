from app.service.bus_stop_links_service import BusStopLinksService
from fastapi import APIRouter

router = APIRouter()
service = BusStopLinksService()

@router.get("/")
def get_all_links():
    return service.get_all()