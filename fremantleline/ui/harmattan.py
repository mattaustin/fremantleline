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
from fremantleline.meta import VERSION
from fremantleline.ui.qml import (Controller, DepartureListModel,
                                  StationListModel, app)
from PySide import QtCore, QtDeclarative, QtGui, QtNetwork, QtOpenGL
import os


view = QtDeclarative.QDeclarativeView()
glw = QtOpenGL.QGLWidget()
view.setViewport(glw)
view.setResizeMode(QtDeclarative.QDeclarativeView.SizeRootObjectToView)

root_context = view.rootContext()
root_context.setContextProperty('version', unicode(VERSION))

network_manager = QtNetwork.QNetworkConfigurationManager()
network_configuration = network_manager.defaultConfiguration()
network_session = QtNetwork.QNetworkSession(network_configuration)
network_session.open()

if network_session.waitForOpened():
    root_context.setContextProperty('controller', Controller(view=view))
    root_context.setContextProperty('station_list', StationListModel())
    root_context.setContextProperty('departure_list', DepartureListModel())

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
