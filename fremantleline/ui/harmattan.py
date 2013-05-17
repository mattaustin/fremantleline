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
from fremantleline.ui.qml import View, app
from PySide.QtOpenGL import QGLWidget


class HarmattanView(View):

    qml_source_platform = 'harmattan'

    def __init__(self, *args, **kwargs):
        super(HarmattanView, self).__init__(*args, **kwargs)
        self.setViewport(QGLWidget())


view = HarmattanView()
view.showFullScreen()
app.exec_()
