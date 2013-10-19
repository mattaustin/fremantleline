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
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.0


Page {

    id: departurePage
    property variant station

    BusyIndicator {
        anchors.centerIn: parent
        running: python.loading
        size: BusyIndicatorSize.Large
        Behavior on opacity {}
    }

    SilicaListView {

        id: departureList
        anchors.fill: parent

        header: PageHeader {
            title: departurePage.station ? departurePage.station.name : 'Departures'
        }

        PullDownMenu {
            MenuItem {
                text: 'Refresh'
                onClicked: {python.getDepartures();}
            }
        }

        ViewPlaceholder {
            enabled: (!python.loading && departureList.count < 1)
            text: 'No departing services were found for this station.'
        }

        delegate: Item {

            width: departureList.width
            implicitHeight: Theme.itemSizeSmall

            Item {

                x: Theme.paddingLarge
                width: parent.width - 2*Theme.paddingLarge
                height: childrenRect.height

                GlassItem {
                    height: parent.height
                    width: Theme.paddingMedium
                    color: (modelData.line == 'Armadale/Thornlie Line' && '#fab20a' ||
                            modelData.line == 'Fremantle Line' && '#155196' ||
                            modelData.line == 'Joondalup Line' && '#97a509' ||
                            modelData.line == 'Mandurah Line' && '#e55e16' ||
                            modelData.line == 'Midland Line' && '#b00257' ||
                            '#16ac48')
                    ratio: 0.0
                    cache: false
                    anchors {
                        left: parent.left
                        leftMargin: (-Theme.paddingLarge/2) + (-Theme.paddingMedium/2)
                    }
                }

                Label {
                    id: title
                    text: modelData.time + ' to ' + modelData.destination
                    font.pixelSize: Theme.fontSizeMedium
                    font.strikeout: (modelData.status == 'CANCELLED')
                    truncationMode: TruncationMode.Fade
                    anchors {
                        left: parent.left
                        right: status.right
                    }
                    opacity: modelData.status == 'CANCELLED' && 0.75 || 1
                }

                Label {
                    id: status
                    text: modelData.status
                    font.pixelSize: Theme.fontSizeExtraSmall
                    font.bold: (modelData.status == 'CANCELLED')
                    horizontalAlignment: Text.AlignRight
                    anchors {
                        right: parent.right
                        baseline: title.baseline
                    }
                }

                Label {
                    id: subtitle
                    text: modelData.subtitle
                    font.pixelSize: Theme.fontSizeExtraSmall * 3/4
                    font.strikeout: (modelData.status == 'CANCELLED')
                    font.italic: true
                    truncationMode: TruncationMode.Fade
                    anchors {
                        top: title.bottom
                        topMargin: 4
                        left: parent.left
                        right: parent.right
                    }
                    opacity: modelData.status == 'CANCELLED' && 0.75 || 1
                }

            }

        }

        VerticalScrollDecorator {}

    }


    Python {

        id: python
        property bool loading: true

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../..').substr('file://'.length));
            addImportPath(Qt.resolvedUrl('../../fremantleline/ui/sailfish').substr('file://'.length));
            importModule('qt5', function() {});
        }

        onError: {
            console.log('python error: ' + traceback);
        }

        function getDepartures() {
            departureList.model = null;
            loading = true;
            call('qt5.pyotherside.get_departures', [departurePage.station.name, departurePage.station.url], function(result) {
                departureList.model = result;
                loading = false;
            });
        }

    }

    onStatusChanged: {
        if (status == PageStatus.Activating) {
            python.getDepartures();
        }
    }

}
