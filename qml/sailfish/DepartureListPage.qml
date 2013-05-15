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
import Sailfish.Silica 1.0


Page {

    id: departurePage
    property alias model: departureList.model
    property variant station

    SilicaListView {

        id: departureList
        anchors.fill: parent
        model: departure_list

        header: PageHeader {
            title: departurePage.station ? departurePage.station.name : 'Departures'
        }

        PullDownMenu {
            MenuItem {
                text: "Refresh"
                onClicked: {controller.stationSelected(departurePage.station);}
            }
        }

        delegate: BackgroundItem {
            width: departureList.width
            Label {
                text: model.title
                color: parent.down ? theme.highlightColor : theme.primaryColor
                anchors.verticalCenter: parent.verticalCenter
                x: theme.paddingLarge
            }
        }

        VerticalScrollDecorator {}

    }

    Column {

        visible: if(departureList.count > 0) false; else true;
        anchors.fill: parent
        anchors.topMargin: theme.itemSizeLarge
        width: departurePage.width
        spacing: theme.paddingLarge

        Label {
            text: 'There are no departing services for this station.'
            width: parent.width - theme.paddingMedium - theme.paddingMedium
            x: theme.paddingMedium
            wrapMode: Text.WordWrap
        }

    }
}
