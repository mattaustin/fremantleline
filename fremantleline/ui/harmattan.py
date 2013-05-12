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

from fremantleline.api import transperth
from fremantleline.meta import VERSION
from fremantleline.ui.qml import StationListModel, app
from PySide import QtCore, QtDeclarative, QtGui, QtNetwork, QtOpenGL
import os
import sys


class DepartureWrapper(QtCore.QObject):
    def __init__(self, departure, *args, **kwargs):
        super(DepartureWrapper, self).__init__(*args, **kwargs)
        self._departure = departure

    def get_direction(self):
        return self._departure.direction.split('To ', 1)[-1]

    def get_title(self):
        title = '%(time)s to %(direction)s' %({
            'time': self._departure.time.strftime('%H:%M'),
            'direction': self.get_direction()})
        if not self._departure.delay == 'On Time':
            title = '%(title)s (%(delay)s)' %({'title': title,
                'delay': self._departure.delay})
        return title

    def get_subtitle(self):
        return self._departure.pattern

    @QtCore.Signal
    def changed(self):
        pass

    title = QtCore.Property(unicode, get_title, notify=changed)
    subtitle = QtCore.Property(unicode, get_subtitle, notify=changed)


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
        departure_list = DepartureListModel(wrapper._station.get_departures())
        view.rootObject().setDepartureModel(departure_list)


view = QtDeclarative.QDeclarativeView()

root_context = view.rootContext()
root_context.setContextProperty('version', unicode(VERSION))

glw = QtOpenGL.QGLWidget()
view.setViewport(glw)
view.setResizeMode(QtDeclarative.QDeclarativeView.SizeRootObjectToView)


network_manager = QtNetwork.QNetworkConfigurationManager()
network_configuration = network_manager.defaultConfiguration()
network_session = QtNetwork.QNetworkSession(network_configuration)
network_session.open()

if network_session.waitForOpened():
    controller = Controller()
    station_list = StationListModel()
    departure_list = DepartureListModel([])

    root_context.setContextProperty('controller', controller)
    root_context.setContextProperty('station_list', station_list)
    root_context.setContextProperty('departure_list', departure_list)

    if os.path.exists('/opt/fremantleline/qml/harmattan'):
        view.setSource('/opt/fremantleline/qml/harmattan/main.qml')
    else:
        view.setSource(os.path.join('qml', 'harmattan', 'main.qml'))
else:
    if os.path.exists('/opt/fremantleline/qml/harmattan'):
        view.setSource('/opt/fremantleline/qml/harmattan/networkError.qml')
    else:
        view.setSource(os.path.join('qml', 'harmattan', 'networkError.qml'))

view.showFullScreen()
view.show()
app.exec_()
