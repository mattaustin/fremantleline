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
from fremantleline.meta import PROJECT_URL, VERSION
from PySide import QtCore
from PySide.QtDeclarative import QDeclarativeView
from PySide.QtNetwork import QNetworkSession, QNetworkConfigurationManager
import threading


class BaseView(QDeclarativeView):

    context_properties = {'version': '{0}'.format(VERSION),
                          'projectUrl': PROJECT_URL}
    window_title = 'Fremantle Line'

    def __init__(self, *args, **kwargs):
        super(BaseView, self).__init__(*args, **kwargs)
        self.setAttribute(QtCore.Qt.WA_OpaquePaintEvent)
        self.setAttribute(QtCore.Qt.WA_NoSystemBackground)
        self.viewport().setAttribute(QtCore.Qt.WA_OpaquePaintEvent)
        self.viewport().setAttribute(QtCore.Qt.WA_NoSystemBackground)

        for key, value in self.get_context_properties().items():
            self.rootContext().setContextProperty(key, value)

        self.setWindowTitle(self.window_title)
        self.setSource(QtCore.QUrl.fromLocalFile(self.get_qml_path()))
        self.setResizeMode(QDeclarativeView.SizeRootObjectToView)

    def get_context_properties(self):
        return self.context_properties.copy()

    def get_qml_path(self):
        raise NotImplementedError()


class NetworkSessionMixin(object):

    def get_network_configuration(self):
        network_manager = QNetworkConfigurationManager()
        network_configuration = network_manager.defaultConfiguration()
        return network_configuration

    def get_network_session(self):
        network_session = QNetworkSession(self.get_network_configuration())
        network_session.open()
        return network_session


class View(NetworkSessionMixin, BaseView):

    platform = 'qml'

    def get_context_properties(self, *args, **kwargs):
        context_properties = super(View, self).get_context_properties(*args,
                                                                      **kwargs)
        context_properties.update({'controller': Controller(view=self),
                                   'station_list': StationListModel(),
                                   'departure_list': DepartureListModel()})
        return context_properties

    def get_qml_path(self):
        if self.get_network_session().waitForOpened():
            return 'qml/{0}/main.qml'.format(self.platform)
        else:
            return 'qml/{0}/networkError.qml'.format(self.platform)


class DepartureWrapper(QtCore.QObject):

    def __init__(self, departure, *args, **kwargs):
        super(DepartureWrapper, self).__init__(*args, **kwargs)
        self._departure = departure

    def get_destination(self):
        return self._departure.destination.split('To ', 1)[-1]

    def get_status(self):
        return '{0}'.format(self._departure.status)

    def get_time(self):
        return self._departure.time.strftime('%H:%M')

    def get_title(self):
        return '{time} to {destination}'.format(
            time=self.get_time(),
            destination=self.get_destination())

    def get_subtitle(self):
        return self._departure.description

    @QtCore.Signal
    def changed(self):
        pass

    title = QtCore.Property(unicode, get_title, notify=changed)
    subtitle = QtCore.Property(unicode, get_subtitle, notify=changed)


class DepartureListModel(QtCore.QAbstractListModel):

    columns = [b'title', b'subtitle', b'destination', b'status', b'time']

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
        if index.isValid() and role == self.columns.index(b'destination'):
            return self._departures[index.row()].get_destination()
        if index.isValid() and role == self.columns.index(b'status'):
            return self._departures[index.row()].get_status()
        if index.isValid() and role == self.columns.index(b'time'):
            return self._departures[index.row()].get_time()


class StationWrapper(QtCore.QObject):

    def __init__(self, station, *args, **kwargs):
        super(StationWrapper, self).__init__(*args, **kwargs)
        self._station = station

    def get_name(self):
        return self._station.name

    @QtCore.Signal
    def changed(self):
        pass

    name = QtCore.Property(unicode, get_name, notify=changed)


class StationListModel(QtCore.QAbstractListModel):

    changed = QtCore.Signal()
    columns = [b'title', b'subtitle', b'station']
    _stations = []

    def __init__(self, *args, **kwargs):
        super(StationListModel, self).__init__(*args, **kwargs)
        self.fetching = False
        self.operator = transperth
        self.fetch_stations()
        self.setRoleNames(dict(enumerate(self.columns)))

    def _fetch_stations(self):
        self.fetching = True
        try:
            stations = self.operator.get_stations()
            self.beginResetModel()
            self._stations = [StationWrapper(station) for station in stations]
            self.endResetModel()
        except:
            raise
        finally:
            self.fetching = False

    def fetch_stations(self):
        if not self._fetching:
            thread = threading.Thread(target=self._fetch_stations)
            thread.start()

    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self._stations)

    def data(self, index, role):
        if index.isValid() and role == self.columns.index(b'title'):
            return self._stations[index.row()].get_name()
        if index.isValid() and role == self.columns.index(b'subtitle'):
            return ''
        if index.isValid() and role == self.columns.index(b'station'):
            return self._stations[index.row()]

    def _get_fetching(self):
        return self._fetching

    def _set_fetching(self, value):
        self._fetching = value
        self.changed.emit()

    fetching = QtCore.Property(bool, _get_fetching, _set_fetching,
                               notify=changed)


class Controller(QtCore.QObject):

    def __init__(self, view, *args, **kwargs):
        super(Controller, self).__init__(*args, **kwargs)
        self.view = view

    @QtCore.Slot(QtCore.QObject)
    def stationSelected(self, wrapper):
        departure_list = DepartureListModel(wrapper._station.get_departures())
        self.view.rootObject().setDepartureModel(departure_list)
