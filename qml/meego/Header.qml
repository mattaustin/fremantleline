// Fremantle Line: Transperth trains live departure information
// Copyright (c) 2009-2015 Matt Austin
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

import QtQuick 1.0


Rectangle {
    property alias title: heading.text
    color: '#3d890c'
    height: 72
    width: parent.width

    Text {
      id: heading
      color: '#ffffff'
      font.pixelSize: 32
      anchors {
        verticalCenter: parent.verticalCenter
        left: parent.left
        right: parent.right
        leftMargin: 16
        rightMargin: 16
      }
    }

    MouseArea {
      anchors.fill: parent
    }
}
