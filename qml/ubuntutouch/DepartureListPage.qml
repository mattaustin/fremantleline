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

import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import io.thp.pyotherside 1.0


Page {

    id: departurePage
    title: 'Departures'

    ActivityIndicator {
        anchors.centerIn: parent
        //running: python.loading
        //size: BusyIndicatorSize.Large
        //Behavior on opacity {}
    }

    ListView {

        id: departureList
        anchors.fill: parent

        delegate: ListItem.Standard {
            width: departureList.width
            //text: modelData.name
            onClicked: {
                //departurePage.station = modelData;
                //pageStack.push(departurePage);
            }
        }

        Scrollbar {
            flickableItem: departureList
        }

    }


    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                text: 'Refresh'
                //iconSource: Qt.resolvedUrl("icon.png")
                onTriggered: print("success!")
            }
        }
        locked: true
        opened: true
    }


}
