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

import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem


Page {

    title: application.station ? application.station.name : 'Departures'
    visible: false

    ActivityIndicator {
        anchors.centerIn: parent
        running: client.busy
    }

    ListView {

        id: departureList
        anchors.fill: parent
        model: application.departureList

        delegate: ListItem.Base {

            height: Math.max(middleVisuals.height, units.gu(6))

//            icon: UbuntuShape {
//                color: (modelData.line_code == 'ARM' && '#fab20a' ||
//                        modelData.line_code == 'FRE' && '#155196' ||
//                        modelData.line_code == 'JDP' && '#97a509' ||
//                        modelData.line_code == 'MAN' && '#e55e16' ||
//                        modelData.line_code == 'MID' && '#b00257' ||
//                        '#16ac48')
//                implicitHeight: parent.height
//                implicitWidth: units.gu(1)
//                radius: 'large'
//            }

            Item  {

                id: middleVisuals
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                height: childrenRect.height + title.anchors.topMargin + subtitle.anchors.bottomMargin

                Label {
                    id: title
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                    enabled: !modelData.is_cancelled
                    font.strikeout: !enabled
                    text: modelData.actual_time + ' to ' + modelData.destination_name
                    opacity: enabled ? 1.0 : 0.5
                }

                Label {
                    id: subtitle
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: title.bottom
                    }
                    color: Theme.palette.normal.backgroundText
                    enabled: !modelData.is_cancelled
                    font.strikeout: !enabled
                    fontSize: 'small'
                    maximumLineCount: 5
                    opacity: enabled ? 1.0 : 0.5
                    text: modelData.description
                    wrapMode: Text.Wrap
                }

                Label {
                    id: status
                    anchors {
                        right: parent.right
                        bottom: title.bottom
                    }
                    color: Theme.palette.normal.overlayText
                    enabled: !modelData.is_cancelled
                    font.bold: !enabled
                    fontSize: 'small'
                    text: modelData.status
                }

            }

            onClicked: {
                application.departure = modelData;
            }

        }

        Scrollbar {
            flickableItem: departureList
        }

    }

    Label {
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: units.gu(4)
            rightMargin: units.gu(4)
            verticalCenter: parent.verticalCenter
        }
        color: Theme.palette.normal.backgroundText
        fontSize: 'large'
        horizontalAlignment: Text.AlignHCenter
        text: 'No departing services were found for this station.'
        visible: !client.busy && station ? (departureList.count < 1) : false
        wrapMode: Text.WordWrap
    }

    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                text: (station ? station.isStarred : false) ? 'Unstar' : 'Star'
                iconSource: (station ? station.isStarred : false) ? Qt.resolvedUrl('image://theme/favorite-selected') : Qt.resolvedUrl('image://theme/favorite-unselected')
                onTriggered: {
                    stations.saveStation(station.url, station.name, !station.isStarred);
                    pageStack.pop();
                    stations.loadStations();
                }
            }
        }
        ToolbarButton {
            action: Action {
                text: 'Refresh'
                iconSource: Qt.resolvedUrl('image://theme/reload')
                onTriggered: {application.getDepartures();}
            }
        }
    }

}
