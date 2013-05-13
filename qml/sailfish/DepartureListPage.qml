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
    property alias title: header.title
    property variant station

    PageHeader {
        id: header
        title: parent.station.name || "Departures"
    }

    SilicaListView {

        id: departureList
        anchors.fill: parent
        anchors.topMargin: header.height
        model: departure_list

        delegate: BackgroundItem {
            width: stationList.width
            Label {
                text: model.title
                color: parent.down ? theme.highlightColor : theme.primaryColor
                anchors.verticalCenter: parent.verticalCenter
                x: theme.paddingLarge
            }
        }

        VerticalScrollDecorator {}

    }

    Label {
        text: "There are no departing services for this station."
        visible: if(departureList.count > 0) false; else true;
        anchors.fill: parent
        anchors.topMargin: header.height + theme.paddingLarge
        anchors.leftMargin: theme.paddingLarge
        anchors.rightMargin: theme.paddingLarge
        wrapMode: Text.WordWrap
    }
}
