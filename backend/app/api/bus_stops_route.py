from app.service.bus_stops_service import BusStopsService
from fastapi import APIRouter, Query

router = APIRouter()
service = BusStopsService()

@router.get("/")
def get_all_bus_stops(page: int = Query(1, ge=1), page_size: int = Query(20, ge=1, le=100)):
    return service.get_all_paginated(page, page_size)

