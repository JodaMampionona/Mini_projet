from fastapi import FastAPI
from app.api import bus_itinerary_route, bus_stops_route, bus_stop_links_route

app = FastAPI()
app.include_router(bus_itinerary_route.router, prefix="/itinerary", tags=["itinerary"])
app.include_router(bus_stops_route.router, prefix="/bus_stops", tags=["bus_stops"])
app.include_router(bus_stop_links_route.router, prefix="/bus_stop_links", tags=["bus_stop_links"])