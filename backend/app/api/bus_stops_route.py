from app.service.bus_stops_service import BusStopsService
from fastapi import APIRouter, Query

router = APIRouter()
service = BusStopsService()


@router.get("/search")
def search_bus_stops(query: str = Query(...)):
    return service.search(query)

@router.get("/")
def get_all_bus_stops(id: int = Query(None), page: int = Query(1, ge=1), page_size: int = Query(400, ge=1, le=500)):
    if id is not None:
        return service.get_by_id(id)
    return service.get_all_paginated(page, page_size)
