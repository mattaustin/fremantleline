# -*- coding: utf-8 -*-
#
# Fremantle Line: Transperth trains live departure information
# Copyright (c) 2009-2014 Matt Austin
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

from distutils.core import setup
from fremantleline import meta
import glob, os, sys


sys.prefix = sys.exec_prefix = '/opt/fremantleline'


def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()


setup(
    name='fremantleline',
    url=meta.PROJECT_URL,
    version='%s' %(meta.VERSION),
    description='Live departure information for Perth metropolitan trains.',
    long_description=read('fremantleline.longdesc'),
    author='Matt Austin',
    author_email='mail@mattaustin.me.uk',
    maintainer='Matt Austin',
    maintainer_email='mail@mattaustin.me.uk',
    packages=['fremantleline', 'fremantleline.api', 'fremantleline.ui'],
    scripts=['scripts/fremantleline'],
    requires=['lxml', 'PySide'],
    data_files=[
        ('/usr/share/applications', ['fremantleline.desktop']),
        ('/opt/fremantleline/icons', glob.glob('icons/*.png')),
        ('/opt/fremantleline/splash', glob.glob('splash/*.png')),
        ('/opt/fremantleline/qml/hildon', glob.glob('qml/hildon/*.qml')),
        ('/opt/fremantleline/qml/meego', glob.glob('qml/meego/*.qml')),
    ],
)
