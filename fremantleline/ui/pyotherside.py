# -*- coding: utf-8 -*-
#
# Fremantle Line: Transperth trains live departure information
# Copyright (c) 2009-2013 Matt Austin
#
# Fremantle Line is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Fremantle Line is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/

from fremantleline.api import Station, transperth


def get_stations():
    return [{'name': s.name, 'url': s.url} for s in transperth.get_stations()]


def get_departures(station_name, station_url):
    station = Station(name=station_name, url=station_url)
    return [{'time': d.time.strftime('%H:%M'),
             'destination': d.destination,
             'status': d.status,
             'line': d.line,
             'subtitle': d.description} for d in station.get_departures()]
