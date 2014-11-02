// Fremantle Line: Transperth trains live departure information
// Copyright (c) 2009-2014 Matt Austin
//
// Fremantle Line is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Fremantle Line is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/

import QtQuick 1.1
import com.nokia.meego 1.0


PageStackWindow {
    initialPage: networkErrorPage

    Page {
        id: networkErrorPage

        Header {
            id: header
            title: 'Perth Trains'
        }

        Text {
            text: 'You must be connected to the internet in order to obtain train departure times.'
            anchors.fill: parent
            anchors.topMargin: header.height + 16
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            font.pixelSize: 24
            wrapMode: Text.WordWrap
        }
    }
}
