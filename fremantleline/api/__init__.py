# -*- coding: utf-8 -*-
#
# Fremantle Line: Transperth trains live departure information
# Copyright (c) 2009-2015 Matt Austin
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

from __future__ import absolute_import
from datetime import time
from fremantleline.api.useragent import URLOpener
from fremantleline.compatibility import UnicodeMixin
import re

try:
    import lxml.etree as ElementTree
    import lxml.html
except ImportError:
    import fremantleline.lib
    import html5lib
    from xml.etree import ElementTree
    lxml = None

try:
    from urllib.parse import urlencode
except ImportError:
    from urllib import urlencode


class Operator(UnicodeMixin, object):
    """Operating company."""

    name = 'Transperth Trains'
    stations = None
    url = 'http://www.transperth.wa.gov.au/Timetables/Live-Train-Times'

    def __repr__(self):
        return '<%s: %s>' % (self.__class__.__name__, self)

    def __unicode__(self):
        return self.name

    def _get_html(self):
        url_opener = URLOpener()
        response = url_opener.open(self.url)
        if lxml:
            html = lxml.html.parse(response).getroot()
        else:
            html = html5lib.parse(response, namespaceHTMLElements=False)
        return html

    def _parse_stations(self, html):
        select = [
            select for select
            in html.findall('.//*div[@id="divTrainLineStationOption"]//select')
            if select.get('name').endswith('TrainStation')][0]
        stations = []
        for option in select.findall('option')[1:]:
            data = urlencode({'stationname': option.get('value')})
            name = '%s' % (option.get('value')).rsplit(' Stn', 1)[0]
            url = '%s?%s' % (self.url, data)
            stations += [Station(name, url)]
        return sorted(stations)

    def get_stations(self):
        """Returns list of Station instances for this operator."""
        if self.stations is None:
            html = self._get_html()
            self.stations = self._parse_stations(html)
        return self.stations


class Station(UnicodeMixin, object):
    """Train station."""

    _departures = None

    def __init__(self, name, url=None):
        self.name = name
        self.url = url  # Legacy url from website scraping, no longer used

    def __repr__(self):
        return '<%s: %s>' % (self.__class__.__name__, self)

    def __unicode__(self):
        return self.name

    def __eq__(self, other):
        return self.name == other.name

    def __ne__(self, other):
        return not self.name == other.name

    def __gt__(self, other):
        return self.name > other.name

    def __lt__(self, other):
        return self.name < other.name

    def __ge__(self, other):
        return self.name >= other.name

    def __le__(self, other):
        return self.name <= other.name

    def _get_departure_data(self):
        base_url = ('http://livetimes.transperth.wa.gov.au/LiveTimes.asmx'
                    '/GetSercoTimesForStation')
        params = {'stationname': '%s Stn' % (self.name)}
        url = '%s?%s' % (base_url, urlencode(params))
        url_opener = URLOpener()
        response = url_opener.open(url)
        tree = ElementTree.parse(response)
        return tree.getroot()

    def _parse_departures(self, data):
        trips = data.findall('.//{http://services.pta.wa.gov.au/}SercoTrip')
        return [Departure(station=self, data=trip) for trip in trips]

    def get_departures(self):
        """Returns Departure instances for this station."""
        if self._departures is None:
            data = self._get_departure_data()
            self._departures = self._parse_departures(data)
        return self._departures


class Departure(object):
    """Departure information."""

    def __init__(self, station, data=None):
        self.station = station
        self._parse_data(data)

    def __repr__(self):
        return '<%(class_name)s: %(time)s %(destination)s %(message)s>' % ({
            'class_name': self.__class__.__name__, 'time': self.actual_time,
            'destination': self.destination_name,
            'message': self.delay_message})

    def _parse_data(self, data):
        self._data = data
        namespace = 'http://services.pta.wa.gov.au/'
        self.id = data.find('{%s}Uid' % (namespace)).text
        self.run = data.find('{%s}Run' % (namespace)).text
        self.scheduled_time = self._parse_time(
            data.find('{%s}Schedule' % (namespace)).text)
        self.actual_time = self._parse_time(
            data.find('{%s}actualDisplayTime24' % (namespace)).text)
        self.delay_seconds = self._parse_integer(
            data.find('{%s}Delay' % (namespace)).text)
        self.delay_minutes = self._parse_integer(
            data.find('{%s}MinutesDelayTime' % (namespace)).text)
        self.delay_message = data.find('{%s}DisplayDelayTime' % (
                                       namespace)).text
        self.destination_name = data.find('{%s}Destination' % (
                                          namespace)).text
        self.line_code = data.find('{%s}Line' % (namespace)).text
        self.line_name = data.find('{%s}LineFull' % (namespace)).text
        self.state = data.find('{%s}State' % (namespace)).text
        self.is_cancelled = self._parse_boolean(
            data.find('{%s}Cancelled' % (namespace)).text)
        self.pattern_code = data.find('{%s}Patterncode' % (namespace)).text
        self.pattern_description = data.find(
            '{%s}PatternFullDisplay' % (namespace)).text
        self.pattern_platforms = self._parse_list(
            data.find('{%s}Pattern' % (namespace)).text)
        self.number_of_cars = self._parse_integer(
            data.find('{%s}Ncar' % (namespace)).text)
        self.platform_code = data.find('{%s}Platform' % (namespace)).text
        self.platform_number = int(re.findall('\d+', self.platform_code)[0])
        self.link = data.find('{%s}Link' % (namespace)).text

    def _parse_boolean(self, text):
        return True if text and text == 'True' else False

    def _parse_integer(self, text):
        return int(text) if text and text.isdigit() else 0

    def _parse_list(self, text):
        return text.split(',') if text else []

    def _parse_time(self, text):
        hour, minute = map(int, text.split(':')[:2])
        hour = hour - 12 if hour >= 24 else hour  # Value goes over 24!
        return time(hour, minute)

    def to_dict(self):
        return {
            'id': self.id,
            'run': self.run,
            'scheduled_time': self.scheduled_time.strftime('%H:%M'),
            'actual_time': self.actual_time.strftime('%H:%M'),
            'delay_seconds': self.delay_seconds,
            'delay_minutes': self.delay_minutes,
            'delay_message': self.delay_message,
            'destination_name': self.destination_name,
            'line_code': self.line_code,
            'line_name': self.line_name,
            'state': self.state,
            'is_cancelled': self.is_cancelled,
            'pattern_code': self.pattern_code,
            'pattern_description': self.pattern_description,
            'pattern_platforms': self.pattern_platforms,
            'number_of_cars': self.number_of_cars,
            'platform_code': self.platform_code,
            'platform_number': self.platform_number,
            'link': self.link,

            'description': self.description,
            'status': self.status,
        }

    @property
    def description(self):
        # Backwards compatibility
        pattern = '%s pattern' % (self.pattern_code) if self.pattern_code \
            else 'All stops'
        return '%s from platform %s (%s cars)' % (
            pattern, self.platform_number, self.number_of_cars)

    @property
    def destination(self):
        # Backwards compatibility
        return self.destination_name

    @property
    def line(self):
        # Backwards compatibility
        return self.line_name

    @property
    def status(self):
        # Backwards compatibility
        message = self.delay_message.strip('()')
        if self.delay_minutes and not self.is_cancelled:
            return '%s min delay' % (self.delay_minutes)
        elif self.is_cancelled:
            return 'CANCELLED'
        else:
            return message

    @property
    def time(self):
        # Backwards compatibility
        return self.actual_time


transperth = Operator()
