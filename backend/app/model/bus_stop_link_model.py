from dataclasses import dataclass
from app.model.bus_model import Bus
from app.model.bus_stop_model import BusStop


@dataclass
class BusStopLink:
    bus: Bus
    stop: BusStop
    rank: int
    id: int = None
