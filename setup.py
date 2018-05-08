#!/usr/bin/env python
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

import codecs
import glob
from os import path

try:
    from setuptools import setup
except ImportError:  # Python 2.5
    from distutils.core import setup

from fremantleline import __license__, __title__, __url__, __version__


BASE_DIR = path.dirname(path.abspath(__file__))


# Get the long description from the README file
readme = codecs.open(path.join(BASE_DIR, 'README.rst'), encoding='utf-8')
long_description = readme.read()
readme.close()


setup(

    name=__title__,

    version=__version__,

    description='Live departure information for Perth metropolitan trains.',
    long_description=long_description,

    url=__url__,

    author='Matt Austin',
    author_email='mail@mattaustin.me.uk',

    license=__license__,

    classifiers=[
        'Development Status :: 4 - Beta',
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.5',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Topic :: Internet',
    ],

    keywords='fremantleline perth trains transport',

    packages=['fremantleline', 'fremantleline.api', 'fremantleline.ui'],

    scripts=['scripts/fremantleline'],

    install_requires=[
        'lxml~=4.2',
    ],

    python_requires='>=2.5, !=3.0.*, !=3.1.*, !=3.2.*, <4',

    # Required for deb/rpm build?
    # data_files=[
    #     ('/usr/share/applications', ['fremantleline.desktop']),
    #     ('/opt/fremantleline/icons', glob.glob('icons/*.png')),
    #     ('/opt/fremantleline/splash', glob.glob('splash/*.png')),
    #     ('/opt/fremantleline/qml/hildon', glob.glob('qml/hildon/*.qml')),
    #     ('/opt/fremantleline/qml/meego', glob.glob('qml/meego/*.qml')),
    # ],

    extras_require={
        'qt': [
            'pyside~=1.2',
        ],
        'tests': [
        ]
    },

)
