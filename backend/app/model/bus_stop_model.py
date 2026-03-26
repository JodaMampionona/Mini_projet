from dataclasses import dataclass, field

from typing import List


@dataclass
class BusStop:
    name: str
    lat: float
    lon: float
    id: int = None
    zone: str = None
    bus: List = field(default_factory=list)
