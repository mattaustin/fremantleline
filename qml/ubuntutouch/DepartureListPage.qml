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
import io.thp.pyotherside 1.0


Page {

    id: departurePage
    property variant station
    title: station ? station.name : 'Departures'
    visible: false

    ActivityIndicator {
        anchors.centerIn: parent
        running: python.loading
    }

    ListView {

        id: departureList
        anchors.fill: parent

        delegate: ListItem.Base {

            height: Math.max(middleVisuals.height, units.gu(6))

            icon: UbuntuShape {
                color: (modelData.line == 'Armadale/Thornlie Line' && '#fab20a' ||
                        modelData.line == 'Fremantle Line' && '#155196' ||
                        modelData.line == 'Joondalup Line' && '#97a509' ||
                        modelData.line == 'Mandurah Line' && '#e55e16' ||
                        modelData.line == 'Midland Line' && '#b00257' ||
                        '#16ac48')
                implicitHeight: parent.height
                implicitWidth: units.gu(1)
                radius: 'large'
            }

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
                    enabled: modelData.status != 'CANCELLED'
                    font.strikeout: !enabled
                    text: modelData.time + ' to ' + modelData.destination
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
                    enabled: modelData.status != 'CANCELLED'
                    font.strikeout: !enabled
                    fontSize: 'small'
                    maximumLineCount: 5
                    opacity: enabled ? 1.0 : 0.5
                    text: modelData.subtitle
                    wrapMode: Text.Wrap
                }

                Label {
                    id: status
                    anchors {
                        right: parent.right
                        bottom: title.bottom
                    }
                    color: Theme.palette.normal.overlayText
                    font.bold: modelData.status == 'CANCELLED'
                    fontSize: 'small'
                    text: modelData.status
                }

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
        visible: (!python.loading && departureList.count < 1)
        wrapMode: Text.WordWrap
    }

    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                text: 'Refresh'
                iconSource: Qt.resolvedUrl('image://theme/reload')
                onTriggered: {python.getDepartures();}
            }
        }
    }


    Python {

        id: python
        property bool loading: true

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('..').substr('file://'.length));
            addImportPath(Qt.resolvedUrl('../fremantleline').substr('file://'.length));
            addImportPath(Qt.resolvedUrl('../fremantleline/ui').substr('file://'.length));
            importModule('ui', function() {});
        }

        onError: {
            console.log('python error: ' + traceback);
        }

        function getDepartures() {
            departureList.model = null;
            loading = true;
            call('ui.pyotherside.get_departures', [departurePage.station.name, departurePage.station.url], function(result) {
                departureList.model = result;
                loading = false;
            });
        }

    }

    onStationChanged: {
        python.getDepartures();
    }

}
