#!/usr/bin/env python
# -*- coding: utf-8 -*-
#    Fremantle Line: Transperth trains live departure information
#    Copyright (C) 2011  Matt Austin
from datetime import datetime
from fremantleline.api.useragent import URLOpener
from urllib import urlencode
import lxml.html


class Operator(object):
    """Operating company."""
    def __init__(self, name, uri):
        self.name = name
        self.uri = uri
    
    def __repr__(self):
        return u'<{class_name}: {name}>'.format(
            class_name=self.__class__.__name__, name=self.name)
    
    def get_stations(self):
        """Returns list of Station instances for this operator."""
        if not getattr(self, '_stations', False):
            stations = []
            url_opener = URLOpener()
            response = url_opener.open(self.uri)
            html = lxml.html.parse(response).getroot()
            options = html.xpath('.//*[@id="EntryForm"]//select/option')
            for option in options:
                name = unicode(option.attrib['value'])
                stations += [Station(name=name, operator=self)]
            self._stations = stations
        return self._stations


class Station(object):
    """Train station."""
    def __init__(self, operator, name):
        self.operator = operator
        self.name = name
    
    def __repr__(self):
        return u'<{class_name}: {name}>'.format(
            class_name=self.__class__.__name__, name=self.name)
    
    def get_departures(self):
        """Returns Departure instances, using information processed from
        the stations departure board html."""
        departures = []
        html = self._get_html()
        rows = html.xpath(
            '//*[@id="dnn_ctr1608_ModuleContent"]//table//table/tr')[1:-1]
        for row in rows:
            cols = row.xpath('td')
            line = cols[0].xpath('img')[0].attrib['title']
            time = datetime.strptime(cols[1].text_content().strip(),
                '%H:%M').time()
            direction = cols[2].text_content().strip()
            pattern = cols[3].text_content().strip()
            delay = cols[5].text_content().strip()
            departures += [Departure(station=self, line=line, time=time,
                direction=direction, pattern=pattern, delay=delay)]
        return departures
    
    def _get_html(self):
        """Returns html from the station's departure board web page."""
        url_opener = URLOpener()
        data = urlencode({'stationname': self.name})
        response = url_opener.open(u'{base_url}?{data}'.format(
            base_url=self.operator.uri, data=data))
        html = lxml.html.parse(response).getroot()
        return html


class Departure(object):
    """Departure information."""
    def __init__(self, station, line=None, time=None, direction=None,
        pattern=None, delay=None):
        self.station = station
        self.line = line
        self.time = time
        self.direction = direction
        self.pattern = pattern
        self.delay = delay
    
    def __repr__(self):
        return u'<{class_name}: {time} {direction} {pattern}>'.format(
            class_name=self.__class__.__name__, time=self.time,
            direction=self.direction, pattern=self.pattern)


transperth = Operator(name='Transperth Trains',
    uri='http://www.transperth.wa.gov.au/TimetablesMaps/LiveTrainTimes.aspx')

