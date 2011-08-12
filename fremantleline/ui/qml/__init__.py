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
from PySide import QtCore, QtDeclarative, QtGui#, QtOpenGL


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
    columns = ['station', 'title']
    
    def __init__(self, *args, **kwargs):
        super(StationListModel, self).__init__(*args, **kwargs)
        stations = transperth.get_stations()
        self._stations = [StationWrapper(station) for station in stations]
        self.setRoleNames(dict(enumerate(self.columns)))
    
    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self._stations)
    
    def data(self, index, role):
        if index.isValid() and role == self.columns.index('station'):
            return self._stations[index.row()]
        if index.isValid() and role == self.columns.index('title'):
            return self._stations[index.row()].get_name()


class Controller(QtCore.QObject):
#    @QtCore.Slot(QtCore.QObject)
#    def podcastSelected(self, wrapper):
#        global view, episodeList
#         view.rootObject().setProperty("state", "Episodes")
#        episodeList = EpisodeListModel(wrapper._podcast._podcast.get_all_episodes())
#        view.rootObject().setEpisodeModel(episodeList)
#        print wrapper._podcast._podcast.__dict__
#    
#    @QtCore.Slot(QtCore.QObject)
#    def episodeSelected(self, wrapper):
#    global view
#    view.rootObject().setProperty("state", "Podcasts")
    pass



app = QtGui.QApplication(sys.argv)
view = QtDeclarative.QDeclarativeView()

controller = Controller()
station_list = StationListModel()

root_context = view.rootContext()
#glw = QtOpenGL.QGLWidget()
#view.setViewport(glw)
#view.setResizeMode(QtDeclarative.QDeclarativeView.SizeRootObjectToView)
root_context.setContextProperty('controller', controller)
root_context.setContextProperty('station_list', station_list)

view.setSource('{path}/main.qml'.format(path=os.path.dirname(__file__)))

view.show()
app.exec_()

