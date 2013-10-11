# -*- coding: utf-8 -*-
from fremantleline.api import Station, transperth


def get_stations():
    return [{'name': s.name, 'url': s.url} for s in transperth.get_stations()]


def get_departures(station_name, station_url):
    station = Station(name=station_name, url=station_url)
    return [{'time': d.time.strftime('%H:%M'),
             'destination': d.destination,
             'status': d.status,
             'subtitle': d.description} for d in station.get_departures()]
