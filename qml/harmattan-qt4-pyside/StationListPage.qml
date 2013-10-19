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


Page {

    id: stationPage
    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-view-menu'
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
            anchors.right: parent==undefined ? undefined : parent.right
        }
    }

    ListView {

        id: stationList
        model: station_list
        anchors.fill: parent
        anchors.topMargin: header.height
        anchors.leftMargin: 16

        delegate: ListDelegate {

            onClicked: {
                departurePage.title = model.station.name;
                departure_list.station = model.station;
                rootWindow.pageStack.push(departurePage);
            }

            Image {
                source: 'image://theme/icon-m-common-drilldown-arrow' + (theme.inverted ? '-inverse' : '')
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
            }

        }

    }

    ScrollDecorator {
        flickableItem: stationList
    }

    Header {
        id: header
        title: 'Perth Trains'
    }

    BusyIndicator {
        platformStyle: BusyIndicatorStyle {size: 'large'}
        anchors.centerIn: parent
        running: station_list.fetching
        visible: station_list.fetching
    }

}
