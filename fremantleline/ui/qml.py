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

from __future__ import absolute_import, unicode_literals
from fremantleline.api import transperth
from fremantleline.meta import VERSION
from PySide import QtCore
from PySide.QtDeclarative import QDeclarativeView
from PySide.QtGui import QApplication
import sys


app = QApplication(sys.argv)


class BaseView(QDeclarativeView):

    context_properties = {'version': '{0}'.format(VERSION)}
    qml_source = None

    def __init__(self, *args, **kwargs):
        super(BaseView, self).__init__(*args, **kwargs)
        self.setAttribute(QtCore.Qt.WA_OpaquePaintEvent)
        self.setAttribute(QtCore.Qt.WA_NoSystemBackground)
        self.viewport().setAttribute(QtCore.Qt.WA_OpaquePaintEvent)
        self.viewport().setAttribute(QtCore.Qt.WA_NoSystemBackground)
        self.setResizeMode(QDeclarativeView.SizeRootObjectToView)

        for key, value in self.get_context_properties().items():
            self.rootContext().setContextProperty(key, value)

        self.setSource(self.get_qml_source())

    def get_context_properties(self):
        return self.context_properties.copy()

    def get_qml_source(self):
        return self.qml_source


class DepartureWrapper(QtCore.QObject):

    def __init__(self, departure, *args, **kwargs):
        super(DepartureWrapper, self).__init__(*args, **kwargs)
        self._departure = departure

    def get_direction(self):
        return self._departure.direction.split('To ', 1)[-1]

    def get_status(self):
        return '{0}'.format(self._departure.delay)

    def get_time(self):
        return self._departure.time.strftime('%H:%M')

    def get_title(self):
        title = '{time} to {direction}'.format(
            time=self.get_time(),
            direction=self.get_direction())
        if not self.get_status() == 'On Time':
            title = '{title} ({status})'.format(
                title=title,
                status=self.get_status())
        return title

    def get_subtitle(self):
        return self._departure.pattern

    @QtCore.Signal
    def changed(self):
        pass

    title = QtCore.Property(unicode, get_title, notify=changed)
    subtitle = QtCore.Property(unicode, get_subtitle, notify=changed)


class DepartureListModel(QtCore.QAbstractListModel):

    columns = [b'title', b'subtitle', b'direction', b'status', b'time']

    def __init__(self, departures=None, **kwargs):
        super(DepartureListModel, self).__init__(**kwargs)
        self._departures = [] if departures is None else [
            DepartureWrapper(departure) for departure in departures]
        self.setRoleNames(dict(enumerate(self.columns)))

    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self._departures)

    def data(self, index, role):
        if index.isValid() and role == self.columns.index(b'title'):
            return self._departures[index.row()].get_title()
        if index.isValid() and role == self.columns.index(b'subtitle'):
            return self._departures[index.row()].get_subtitle()
        if index.isValid() and role == self.columns.index(b'direction'):
            return self._departures[index.row()].get_direction()
        if index.isValid() and role == self.columns.index(b'status'):
            return self._departures[index.row()].get_status()
        if index.isValid() and role == self.columns.index(b'time'):
            return self._departures[index.row()].get_time()


class StationWrapper(QtCore.QObject):

    def __init__(self, station, *args, **kwargs):
        super(StationWrapper, self).__init__(*args, **kwargs)
        self._station = station

    def get_name(self):
        return self._station.name.rsplit(' Stn', 1)[0]

    @QtCore.Signal
    def changed(self):
        pass

    name = QtCore.Property(unicode, get_name, notify=changed)


class StationListModel(QtCore.QAbstractListModel):

    columns = [b'title', b'subtitle', b'station']

    def __init__(self, *args, **kwargs):
        super(StationListModel, self).__init__(*args, **kwargs)
        stations = transperth.get_stations()
        self._stations = [StationWrapper(station) for station in stations]
        self.setRoleNames(dict(enumerate(self.columns)))

    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self._stations)

    def data(self, index, role):
        if index.isValid() and role == self.columns.index(b'title'):
            return self._stations[index.row()].get_name()
        if index.isValid() and role == self.columns.index(b'subtitle'):
            return u''
        if index.isValid() and role == self.columns.index(b'station'):
            return self._stations[index.row()]


class Controller(QtCore.QObject):

    def __init__(self, view, *args, **kwargs):
        super(Controller, self).__init__(*args, **kwargs)
        self.view = view

    @QtCore.Slot(QtCore.QObject)
    def stationSelected(self, wrapper):
        departure_list = DepartureListModel(wrapper._station.get_departures())
        self.view.rootObject().setDepartureModel(departure_list)
