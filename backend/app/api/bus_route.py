from fastapi import APIRouter, HTTPException, Query
from typing import Optional
from app.service.bus_service import BusService

router = APIRouter()
service = BusService()

# endpoint pour /bus et /bus/?bus_id
@router.get("/")
def get_buses(bus_id: Optional[int] = Query(None)):
    if bus_id is not None:
        bus_details = service.get_bus_details_with_stops(bus_id)
        if not bus_details:
            raise HTTPException(status_code=404, detail="Bus non trouvé")
        return bus_details
    return service.get_buses_simple_list()
