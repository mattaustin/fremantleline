# -*- coding: utf-8 -*-
#
# Fremantle Line: Transperth trains live departure information
# Copyright (c) 2009-2014 Matt Austin
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
from datetime import datetime
from fremantleline.api.useragent import URLOpener
from fremantleline.compatibility import UnicodeMixin

try:
    import lxml.html
except ImportError:
    import fremantleline.lib
    import html5lib
    lxml = None

try:
    from urllib.parse import urlencode
except ImportError:
    from urllib import urlencode


class Operator(UnicodeMixin, object):
    """Operating company."""

    name = 'Transperth Trains'
    stations = None
    url = 'http://www.transperth.wa.gov.au/TimetablesMaps/LiveTrainTimes.aspx'

    def __repr__(self):
        return '<%s: %s>' %(self.__class__.__name__, self)

    def __unicode__(self):
        return self.name

    def _get_html(self):
        url_opener = URLOpener()
        response = url_opener.open(self.url)
        if lxml:
            html = lxml.html.parse(response).getroot()
        else:
            html = html5lib.parse(response)
        return html

    def _parse_stations(self, html):
        ns = html.get('xmlns', '')
        options = html.findall(
            './/*[@id="EntryForm"]//{%(ns)s}select/{%(ns)s}option' %({'ns':ns}))
        stations = []
        for option in options:
            data = urlencode({'stationname': option.get('value')})
            name = '%s' %(option.get('value')).rsplit(' Stn', 1)[0]
            url = '%s?%s' %(self.url, data)
            stations += [Station(name, url)]
        return stations

    def get_stations(self):
        """Returns list of Station instances for this operator."""
        if self.stations is None:
            html = self._get_html()
            self.stations = self._parse_stations(html)
        return self.stations


class Station(UnicodeMixin, object):
    """Train station."""

    departures = None

    def __init__(self, name, url):
        self.name = name
        self.url = url

    def __repr__(self):
        return '<%s: %s>' %(self.__class__.__name__, self)

    def __unicode__(self):
        return self.name

    def _get_html(self):
        url_opener = URLOpener()
        response = url_opener.open(self.url)
        if lxml:
            html = lxml.html.parse(response).getroot()
        else:
            html = html5lib.parse(response)
        return html

    def _parse_departures(self, html):
        ns = html.get('xmlns', '')
        rows = html.findall(
            './/*[@id="dnn_ctr1608_ModuleContent"]//{%(ns)s}table'
            '//{%(ns)s}table//{%(ns)s}tr' %({'ns':ns}))[1:-1]
        return [Departure(self, row) for row in rows]

    def get_departures(self):
        """Returns Departure instances for this station."""
        if self.departures is None:
            html = self._get_html()
            self.departures = self._parse_departures(html)
        return self.departures


class Departure(object):
    """Departure information.]"""

    def __init__(self, station, row_data):
        self.station = station
        self._cols = row_data

    def __repr__(self):
        return '<%(class_name)s: %(time)s %(destination)s %(status)s>' %({
            'class_name': self.__class__.__name__, 'time': self.time,
            'destination': self.destination, 'status': self.status})

    def _get_text_content(self, element):
        return ''.join(element.itertext()).strip()

    @property
    def description(self):
        return self._get_text_content(self._cols[3])

    @property
    def destination(self):
        content = self._get_text_content(self._cols[2])
        return content.split('To ', 1)[-1]

    @property
    def line(self):
        return self._cols[0][0].get('title')

    @property
    def status(self):
        return self._get_text_content(self._cols[5])

    @property
    def time(self):
        content = self._get_text_content(self._cols[1])
        return datetime.strptime(content, '%H:%M').time()

transperth = Operator()
