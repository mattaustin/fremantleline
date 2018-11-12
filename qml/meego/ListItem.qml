// Fremantle Line: Transperth trains live departure information
// Copyright (c) 2009-2018 Matt Austin
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


Item {

    id: listItem
    height: 80
    width: parent.width

    Row {

        anchors.fill: parent
        spacing: 16

        Column {

            anchors.verticalCenter: parent.verticalCenter

            Label {
                id: title
                text: model.time + ' to ' + model.destination
                font.family: "Nokia Pure Text"
                color: "#282828"
                font.pixelSize: 26
                font.strikeout: model.status == 'CANCELLED'
                font.weight: Font.Bold
                opacity: model.status == 'CANCELLED' && 0.5 || 1
            }

            Label {
                id: subtitle
                text: model.subtitle
                color: "#505050"
                font.family: "Nokia Pure Text Light"
                font.pixelSize: 22
                font.strikeout: model.status == 'CANCELLED'
                font.weight: Font.Normal
                opacity: model.status == 'CANCELLED' && 0.5 || 1
            }

        }

    }

}
