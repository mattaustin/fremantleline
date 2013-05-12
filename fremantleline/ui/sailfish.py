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
from fremantleline.ui.qml import BaseView, StationListModel, app
import os


class View(BaseView):

    qml_source = os.path.join('qml', 'sailfish', 'main.qml')

    def get_context_properties(self, *args, **kwargs):
        context_properties = super(View, self).get_context_properties(*args,
                                                                      **kwargs)
        context_properties.update({'station_list': StationListModel()})
        return context_properties


view = View()
view.show()
app.exec_()
