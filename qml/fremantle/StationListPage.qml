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

import QtQuick 1.0
import org.hildon.components 1.0


Page {

    id: stationPage

    tools: MenuLayout {
        MenuItem {
            text: 'About'
            onClicked: {
                aboutDialog.open();
            }
        }
        MenuItem {
            text: 'Project homepage'
            onClicked: {Qt.openUrlExternally(projectUrl)}
        }
    }

    ListView {

        id: stationList
        anchors.fill: parent
        model: station_list

        delegate: ListItem {
            width: stationList.width
            Label {
                text: model.title
                font.pixelSize: 30
                anchors.verticalCenter: parent.verticalCenter
                x: platformStyle.paddingLarge
            }
            onClicked: {
                departure_list.station = model.station;
                pageStack.push(departurePage);
            }
        }

        ScrollDecorator {
            flickableItem: stationList
        }

    }

}
