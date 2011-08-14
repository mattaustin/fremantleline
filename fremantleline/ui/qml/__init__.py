# -*- coding: utf-8 -*-
#
# Fremantle Line: Transperth trains live departure information
# Copyright (c) 2009-2011 Matt Austin
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

import os
import sys
from fremantleline.api import transperth
from PySide import QtCore, QtDeclarative, QtGui, QtOpenGL


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


class DepartureWrapper(QtCore.QObject):
    def __init__(self, departure, *args, **kwargs):
        super(DepartureWrapper, self).__init__(*args, **kwargs)
        self._departure = departure
    
    def get_direction(self):
        return self._departure.direction.split('To ', 1)[-1]
    
    def get_title(self):
        return '%(time)s to %(direction)s' %({
            'time': self._departure.time.strftime('%H:%M'),
            'direction': self.get_direction()})
    
    def get_subtitle(self):
        return self._departure.pattern
    
    @QtCore.Signal
    def changed(self):
        pass
    
    title = QtCore.Property(unicode, get_title, notify=changed)
    subtitle = QtCore.Property(unicode, get_subtitle, notify=changed)


class StationListModel(QtCore.QAbstractListModel):
    columns = ['title', 'subtitle', 'station']
    
    def __init__(self, *args, **kwargs):
        super(StationListModel, self).__init__(*args, **kwargs)
        stations = transperth.get_stations()
        self._stations = [StationWrapper(station) for station in stations]
        self.setRoleNames(dict(enumerate(self.columns)))
    
    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self._stations)
    
    def data(self, index, role):
        if index.isValid() and role == self.columns.index('title'):
            return self._stations[index.row()].get_name()
        if index.isValid() and role == self.columns.index('subtitle'):
            return ''
        if index.isValid() and role == self.columns.index('station'):
            return self._stations[index.row()]


class DepartureListModel(QtCore.QAbstractListModel):
    columns = ['title', 'subtitle', 'direction']
    
    def __init__(self, departures, *args, **kwargs):
        super(DepartureListModel, self).__init__(*args, **kwargs)
        self._departures = [DepartureWrapper(departure) for departure in \
            departures]
        self.setRoleNames(dict(enumerate(self.columns)))
    
    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self._departures)
    
    def data(self, index, role):
        if index.isValid() and role == self.columns.index('title'):
            return self._departures[index.row()].get_title()
        if index.isValid() and role == self.columns.index('subtitle'):
            return self._departures[index.row()].get_subtitle()
        if index.isValid() and role == self.columns.index('direction'):
            return self._departures[index.row()].get_direction()


class Controller(QtCore.QObject):
    @QtCore.Slot(QtCore.QObject)
    def stationSelected(self, wrapper):
        global view
        #view.rootObject().setProperty('state', 'Departures')
        departure_list = DepartureListModel(wrapper._station.get_departures())
        view.rootObject().setDepartureModel(departure_list)


app = QtGui.QApplication(sys.argv)
view = QtDeclarative.QDeclarativeView()

controller = Controller()
station_list = StationListModel()
departure_list = DepartureListModel([])

root_context = view.rootContext()
glw = QtOpenGL.QGLWidget()
view.setViewport(glw)
view.setResizeMode(QtDeclarative.QDeclarativeView.SizeRootObjectToView)

root_context.setContextProperty('controller', controller)
root_context.setContextProperty('station_list', station_list)
root_context.setContextProperty('departure_list', departure_list)

view.setSource('%(path)s/main.qml' %({'path': os.path.dirname(__file__)}))
view.showFullScreen()
view.show()
app.exec_()

