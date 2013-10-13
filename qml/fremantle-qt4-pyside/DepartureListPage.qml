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

import QtQuick 1.0
import org.hildon.components 1.0


Page {

    id: departurePage
    title: departure_list.station ? departure_list.station.name : 'Departures'

    tools: MenuLayout {
        MenuItem {
            text: 'Refresh'
            onClicked: {departure_list.station = departure_list.station;}
        }
    }

    ListView {

        id: departureList
        anchors.fill: parent
        model: departure_list

        delegate: Item {

            width: departureList.width
            height: 100

            Image {
                id: background
                z: -1
                anchors.fill: parent
                smooth: true
                source: 'image://theme/TouchListBackgroundNormal'
            }

            Item {

                x: platformStyle.paddingLarge
                width: parent.width - 2*platformStyle.paddingLarge
                height: title.height + subtitle.height
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    id: title
                    text: model.time + ' to ' + model.destination
                    font.pixelSize: 30
                    anchors {
                        left: parent.left
                        right: status.right
                    }
                }

                Label {
                    id: status
                    text: model.status
                    font.pixelSize: 26
                    horizontalAlignment: Text.AlignRight
                    anchors {
                        right: parent.right
                        baseline: title.baseline
                    }
                    opacity: 0.5
                }

                Label {
                    id: subtitle
                    text: model.subtitle
                    font.pixelSize: 22
                    anchors {
                        top: title.bottom
                        left: parent.left
                        right: parent.right
                    }
                    opacity: 0.5
                }

            }

        }

        ScrollDecorator {
            flickableItem: departureList
        }

    }

    Label {
        text: 'No departing services were found for this station.'
        visible: (!departure_list.fetching && departureList.count < 1)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 30
            rightMargin: 30
            verticalCenter: parent.verticalCenter
        }
        font.pixelSize: 30
        wrapMode: Text.WordWrap
        opacity: 0.5
    }

}
