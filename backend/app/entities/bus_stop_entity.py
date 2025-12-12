from dataclasses import dataclass


@dataclass
class BusStopEntity:
    name: str
    lat: float
    lon: float
    id: int = None
