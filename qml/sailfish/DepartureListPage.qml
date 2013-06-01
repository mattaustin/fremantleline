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

    SilicaListView {

        id: departureList
        anchors.fill: parent
        model: departure_list

        header: PageHeader {
            title: departure_list.station ? departure_list.station.name : 'Departures'
        }

        PullDownMenu {
            MenuItem {
                text: 'Refresh'
                onClicked: {departure_list.station = departure_list.station;}
            }
        }

        delegate: Item {

            width: departureList.width
            implicitHeight: theme.itemSizeSmall

            Item {

                x: theme.paddingLarge
                width: parent.width - 2*theme.paddingLarge
                height: childrenRect.height

                Label {
                    id: title
                    text: model.time + ' to ' + model.destination
                    font.pixelSize: theme.fontSizeMedium
                    truncationMode: TruncationMode.Fade
                    anchors {
                        left: parent.left
                        right: status.right
                    }
                }

                Label {
                    id: status
                    text: model.status
                    font.pixelSize: theme.fontSizeExtraSmall
                    horizontalAlignment: Text.AlignRight
                    anchors {
                        right: parent.right
                        baseline: title.baseline
                    }
                }

                Label {
                    id: subtitle
                    text: model.subtitle
                    font.pixelSize: theme.fontSizeExtraSmall * 3/4
                    font.italic: true
                    truncationMode: TruncationMode.Fade
                    anchors {
                        top: title.bottom
                        topMargin: 4
                        left: parent.left
                        right: parent.right
                    }
                }

            }

        }

        VerticalScrollDecorator {}

    }

    Column {

        visible: departureList.count < 1
        anchors.fill: parent
        anchors.topMargin: theme.itemSizeLarge
        width: departurePage.width
        spacing: theme.paddingLarge

        Label {
            text: departure_list.fetching ? 'Loading...' : 'No departing services were found for this station.'
            width: parent.width - theme.paddingLarge - theme.paddingLarge
            x: theme.paddingLarge
            wrapMode: Text.WordWrap
        }

    }
}
