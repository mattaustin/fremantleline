# -*- coding: utf-8 -*-
#
# Fremantle Line: Transperth trains live departure information
# Copyright (c) 2009-2018 Matt Austin
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
from fremantleline.api import transperth
from fremantleline.meta import PROJECT_URL, VERSION
from PySide import QtCore
from PySide.QtDeclarative import QDeclarativeView
from PySide.QtNetwork import QNetworkSession, QNetworkConfigurationManager
import threading


class BaseView(QDeclarativeView):

    context_properties = {'version': '%s ' % (VERSION),
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

    components = 'qml'

    def get_context_properties(self, *args, **kwargs):
        context_properties = super(View, self).get_context_properties(*args,
                                                                      **kwargs)
        context_properties.update({'station_list': StationListModel(),
                                   'departure_list': DepartureListModel()})
        return context_properties

    def get_qml_path(self):
        if self.get_network_session().waitForOpened():
            return 'qml/%s/main.qml' % (self.components)
        else:
            return 'qml/%s/networkError.qml' % (self.components)


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


class DepartureWrapper(QtCore.QObject):

    def __init__(self, departure, *args, **kwargs):
        super(DepartureWrapper, self).__init__(*args, **kwargs)
        self._departure = departure

    def get_destination(self):
        return self._departure.destination

    def get_line(self):
        return self._departure.line

    def get_status(self):
        return self._departure.status

    def get_time(self):
        return self._departure.time.strftime('%H:%M')

    def get_title(self):
        return '%(time)s to %(destination)s' % ({
            'time': self.get_time(),
            'destination': self.get_destination()})

    def get_subtitle(self):
        return self._departure.description

    title = QtCore.Property(unicode, get_title)
    subtitle = QtCore.Property(unicode, get_subtitle)


class BaseListModel(QtCore.QAbstractListModel):

    items = []

    def __init__(self, *args, **kwargs):
        super(BaseListModel, self).__init__(*args, **kwargs)
        self._roles = sorted(self.roles.items())
        self.setRoleNames(
            dict(enumerate('%s' % (k) for k, v in self._roles)))

    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self.items)

    def data(self, index, role):
        if index.isValid():
            item = self.items[index.row()]
            role_name, func = self._roles[role]
            return func(item)


class StationListModel(BaseListModel):

    _fetching = False
    changed = QtCore.Signal()
    roles = {'title': lambda i: i.get_name(),
             'subtitle': lambda i: '',
             'station': lambda i: i}

    def __init__(self, *args, **kwargs):
        super(StationListModel, self).__init__(*args, **kwargs)
        self.operator = transperth
        self.fetch_stations()

    def _fetch_stations(self):
        self.fetching = True
        try:
            stations = self.operator.get_stations()
            self.beginResetModel()
            self.items = [StationWrapper(station) for station in stations]
            self.endResetModel()
        except:
            raise
        finally:
            self.fetching = False

    def _get_fetching(self):
        return self._fetching

    def _set_fetching(self, value):
        self._fetching = value
        self.changed.emit()

    def fetch_stations(self):
        if not self._fetching:
            thread = threading.Thread(target=self._fetch_stations)
            thread.start()

    fetching = QtCore.Property(bool, _get_fetching, _set_fetching,
                               notify=changed)


class DepartureListModel(BaseListModel):

    _station = None
    _fetching = False
    changed = QtCore.Signal()
    roles = {'title': lambda i: i.title,
             'subtitle': lambda i: i.subtitle,
             'destination': lambda i: i.get_destination(),
             'status': lambda i: i.get_status(),
             'line': lambda i: i.get_line(),
             'time': lambda i: i.get_time()}

    def _empty_items(self):
        self.beginResetModel()
        self._station._station.departures = None
        self.items = []
        self.endResetModel()

    def _get_station(self):
        return self._station

    def _set_station(self, value):
        self._station = value
        self.fetch_departures()

    station = QtCore.Property(StationWrapper, _get_station, _set_station,
                              notify=changed)

    def _fetch_departures(self):
        self.fetching = True
        self._empty_items()
        try:
            departures = self._station._station.get_departures()
            self.beginResetModel()
            self.items = [DepartureWrapper(d) for d in departures]
            self.endResetModel()
        except:
            raise
        finally:
            self.fetching = False

    def _get_fetching(self):
        return self._fetching

    def _set_fetching(self, value):
        self._fetching = value
        self.changed.emit()

    def fetch_departures(self):
        if not self._fetching:
            thread = threading.Thread(target=self._fetch_departures)
            thread.start()

    fetching = QtCore.Property(bool, _get_fetching, _set_fetching,
                               notify=changed)
