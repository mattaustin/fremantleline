# -*- coding: utf-8 -*-
#
# Fremantle Line: Transperth trains live departure information
# Copyright (c) 2009-2015 Matt Austin
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
from fremantleline.meta import PROJECT_URL, VERSION

try:
    from urllib.request import FancyURLopener
except ImportError:
    from urllib import FancyURLopener


class URLOpener(FancyURLopener):

    version = 'FremantleLine/%(version)s (Fremantle Line; +%(url)s)' % ({
        'version': VERSION, 'url': PROJECT_URL})
