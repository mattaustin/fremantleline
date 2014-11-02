// Fremantle Line: Transperth trains live departure information
// Copyright (c) 2009-2014 Matt Austin
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

    property alias title: header.title

    id: departurePage
    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {rootWindow.pageStack.pop();}
        }

        ToolIcon {
            iconId: 'toolbar-refresh'
            onClicked: {departure_list.station = departure_list.station;}
        }
    }

    ListView {

        id: departureList
        model: departure_list
        anchors.fill: parent
        anchors.topMargin: header.height
        anchors.leftMargin: 16
        anchors.rightMargin: 16

        delegate: ListItem {

            id: listItem

            Rectangle {
                height: parent.height - 4
                width: 8
                color: (model.line == 'Armadale/Thornlie Line' && '#fab20a' ||
                        model.line == 'Armadale Line' && '#fab20a' ||
                        model.line == 'Thornlie Line' && '#fab20a' ||
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
                color: model.status == 'CANCELLED' && "#282828" || "#505050"
                font.pixelSize: 22
                font.bold: model.status == 'CANCELLED'
                horizontalAlignment: Text.AlignRight
                anchors {
                    right: parent.right
                    top: parent.top
                    topMargin: 12
                }
            }

        }

    }

    ScrollDecorator {
        flickableItem: departureList
    }

    Header {
        id: header
        title: 'Departures'
    }

    Text {
        text: 'No departing services were found for this station.'
        visible: (!departure_list.fetching && departureList.count < 1)
        anchors.fill: parent
        anchors.topMargin: header.height + 16
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        font.pixelSize: 24
        wrapMode: Text.WordWrap
    }

    BusyIndicator {
        platformStyle: BusyIndicatorStyle {size: 'large'}
        anchors.centerIn: parent
        running: departure_list.fetching
        visible: departure_list.fetching
    }

}
