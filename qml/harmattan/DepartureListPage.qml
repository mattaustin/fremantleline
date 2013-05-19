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


Page {
    property alias model: departureList.model
    property alias title: header.title
    property variant station

    id: departurePage
    orientationLock: PageOrientation.LockPortrait
    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {rootWindow.pageStack.pop();}
        }

        ToolIcon {
            iconId: "toolbar-refresh"
            onClicked: {controller.stationSelected(departurePage.station);}
        }
    }

    Item {
        anchors.fill: parent
        anchors.topMargin: header.height

        DepartureList {
            id: departureList
            model: departure_list
        }

        ScrollDecorator {
            flickableItem: departureList
        }
    }

    Header {
        id: header
        title: departurePage.station ? departurePage.station.name : 'Departures'
    }

    Text {
        text: "There are no departing services for this station."
        visible: if(departureList.count > 0) false; else true;
        anchors.fill: parent
        anchors.topMargin: header.height + 16
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        font.pixelSize: 24
        wrapMode: Text.WordWrap
    }
}
