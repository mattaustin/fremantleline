// Fremantle Line: Transperth trains live departure information
// Copyright (c) 2009-2018 Matt Austin
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
        // Clear any selected station when this page is activated
        if (status == PageStatus.Active) {
            application.station = null;
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: (stations.busy || client.busy) && stationList.count < 1
        size: BusyIndicatorSize.Large
        Behavior on opacity {}
    }

    SilicaListView {

        id: stationList
        anchors.fill: parent
        model: application.stationList

        header: PageHeader {
            title: 'Perth Trains'
        }

        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: 'Clear & reload station data'
                onClicked: {
                    stations.clearDatabase();
                    stations.loadStations();
                }
            }
            MenuItem {
                text: 'About'
                onClicked: {
                    pullDownMenu.close();
                    pageStack.push(Qt.resolvedUrl('AboutDialog.qml'))
                }
            }
            MenuItem {
                text: 'Project homepage'
                onClicked: {Qt.openUrlExternally(client.projectUrl)}
            }
        }

        delegate: Item {

            id: stationItem
            height: contentItem.height + contextMenu.height
            width: stationList.width

            BackgroundItem {

                id: contentItem
                width: parent.width

                onClicked: {
                    application.station = model;
                }

                onPressAndHold: {
                    contextMenu.show(stationItem);
                }

                Label {
                    text: model.name
                    font.bold: model.isStarred
                    color: contentItem.down ? Theme.highlightColor : Theme.primaryColor
                    anchors.verticalCenter: parent.verticalCenter
                    x: Theme.paddingLarge
                }

            }

            ContextMenu {
                id: contextMenu
                MenuItem {
                    text: model.isStarred ? 'Unpin' : 'Pin to top'
                    onClicked: {
                        contextMenu.hide();
                        stations.saveStation(model.url, model.name, !model.isStarred);
                        stations.loadStations();
                    }
                }
            }

        }

        VerticalScrollDecorator {}

    }

}
