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

from __future__ import absolute_import
from fremantleline.ui.pyside import View
from PySide.QtGui import QApplication
from PySide.QtOpenGL import QGLWidget
import sys


class HarmattanView(View):

    platform = 'harmattan'

    def __init__(self, *args, **kwargs):
        super(HarmattanView, self).__init__(*args, **kwargs)
        self.setViewport(QGLWidget())


def main():
    app = QApplication(sys.argv)
    view = HarmattanView()
    view.showFullScreen()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
