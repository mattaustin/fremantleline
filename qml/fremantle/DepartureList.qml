// Fremantle Line: Transperth trains live departure information
// Copyright (c) 2009-2013 Matt Austin
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
import org.maemo.fremantle 1.0
import org.maemo.extras 1.0


ListView {

    id: departureListView
    anchors.fill: parent
    anchors.leftMargin: 16
    anchors.rightMargin: 16

    delegate: ListDelegate {

        id: listItem

        Label {
            id: status
            text: model.status
            font.family: listItem.subtitleFont
            font.pixelSize: listItem.subtitleSize
            color: listItem.pressed ? listItem.titleColorPressed : listItem.titleColor
            horizontalAlignment: Text.AlignRight
            anchors {
                right: parent.right
                top: parent.top
                topMargin: 12
            }
        }

    }

}
