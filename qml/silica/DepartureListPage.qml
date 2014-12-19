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
import Sailfish.Silica 1.0


Page {

    onStatusChanged: {
        // Clear any selected departure when this page is activated
        if (status == PageStatus.Active) {
            application.departure = null;
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: client.busy
        size: BusyIndicatorSize.Large
        Behavior on opacity {}
    }

    SilicaListView {

        id: departureList

        anchors.fill: parent
        model: application.departureList

        header: PageHeader {
            title: application.station ? application.station.name : 'Departures'
        }

        PullDownMenu {
            MenuItem {
                text: 'Refresh'
                onClicked: {application.getDepartures();}
            }
        }

        ViewPlaceholder {
            enabled: (!client.busy && departureList.count < 1)
            text: 'No departing services were found for this station.'
        }

        delegate: BackgroundItem {

            id: departureItem

            width: departureList.width
            implicitHeight: Theme.itemSizeMedium

            onClicked: {
                application.departure = modelData;
            }

            Item {
                x: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 2*Theme.paddingLarge
                height: childrenRect.height

                Rectangle {
                    width: Theme.paddingSmall
                    radius: Math.round(height/3)
                    color: (modelData.line_code == 'ARM' && '#fab20a' ||
                            modelData.line_code == 'FRE' && '#155196' ||
                            modelData.line_code == 'JDP' && '#97a509' ||
                            modelData.line_code == 'MAN' && '#e55e16' ||
                            modelData.line_code == 'MID' && '#b00257' ||
                            '#16ac48')
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        topMargin: Theme.paddingSmall/2
                        bottomMargin: Theme.paddingSmall/2
                        leftMargin: -width/2
                    }
                }

                Label {
                    id: title
                    enabled: !modelData.is_cancelled
                    text: modelData.actual_time + ' to ' + modelData.destination_name
                    color: departureItem.down ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeLarge
                    font.strikeout: !enabled
                    truncationMode: TruncationMode.Fade
                    anchors {
                        left: parent.left
                        right: status.left
                        leftMargin: Theme.paddingLarge
                        rightMargin: Theme.paddingLarge
                    }
                    opacity: enabled ? 1 : 0.75
                }

                Label {
                    id: status
                    enabled: !modelData.is_cancelled
                    text: modelData.status
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: !enabled
                    horizontalAlignment: Text.AlignRight
                    anchors {
                        right: parent.right
                        baseline: title.baseline
                    }
                }

                Label {
                    id: subtitle
                    enabled: !modelData.is_cancelled
                    text: modelData.description
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeExtraSmall
                    font.strikeout: !enabled
                    truncationMode: TruncationMode.Fade
                    anchors {
                        top: title.bottom
                        left: parent.left
                        right: parent.right
                        leftMargin: Theme.paddingLarge
                    }
                    opacity: enabled ? 1 : 0.75
                }

            }

        }

        VerticalScrollDecorator {}

    }

}
