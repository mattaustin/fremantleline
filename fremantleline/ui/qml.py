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


#class Controller(QtCore.QObject):

#    @QtCore.Slot(QtCore.QObject)
#    def stationSelected(self, wrapper):
#        global view
#        departure_list = DepartureListModel(wrapper._station.get_departures())
#        view.rootObject().setDepartureModel(departure_list)
