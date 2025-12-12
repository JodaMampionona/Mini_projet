from dataclasses import dataclass
from app.entities.bus_entity import BusEntity
from app.entities.bus_stop_entity import BusStopEntity


@dataclass
class BusStopLinkEntity:
    bus: BusEntity
    stop: BusStopEntity
    rank: int
    id: int = None
