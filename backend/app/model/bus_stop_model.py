from dataclasses import dataclass

@dataclass
class BusStop:
    name: str
    lat: float
    lon: float
    id: int = None