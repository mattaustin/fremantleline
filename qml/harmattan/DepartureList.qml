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
import com.nokia.meego 1.0
import com.nokia.extras 1.0


ListView {

    id: departureListView
    anchors.fill: parent
    anchors.leftMargin: 16
    anchors.rightMargin: 16

    delegate: ListDelegate {

        id: listItem
        opacity: model.status == 'CANCELLED' && 0.5 || 1

        Rectangle {
            height: parent.height - 4
            width: 8
            color: (model.line == 'Armadale/Thornlie Line' && '#fab20a' ||
                    model.line == 'Fremantle Line' && '#155196' ||
                    model.line == 'Joondalup Line' && '#97a509' ||
                    model.line == 'Mandurah Line' && '#e55e16' ||
                    model.line == 'Midland Line' && '#b00257' ||
                    '#16ac48')
            anchors {
                left: parent.left
                leftMargin: -14
                top: parent.top
                topMargin: 2
            }
        }

        Label {
            id: status
            text: model.status
            font.family: listItem.subtitleFont
            font.pixelSize: listItem.subtitleSize
            font.bold: model.status == 'CANCELLED'
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
