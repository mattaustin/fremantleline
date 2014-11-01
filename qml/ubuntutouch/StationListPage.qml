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
import Ubuntu.Components.Popups 0.1


Page {

    id: stationPage
    title: 'Perth Trains'
    visible: false

    ActivityIndicator {
        anchors.centerIn: parent
        running: stations.busy || client.busy
    }

    ListView {

        id: stationList
        anchors.fill: parent
        model: stations.model

        delegate: ListItem.Standard {
            width: stationList.width
            text: model.name
            progression: true
            onClicked: {
                departurePage.station = model;
                pageStack.push(departurePage);
            }
        }

        Scrollbar {
            flickableItem: stationList
        }

    }


    Component {
        id: actionSelectionPopover

        ActionSelectionPopover {
            actions: ActionList {
                Action {
                    text: 'About'
                    onTriggered: {PopupUtils.open(aboutDialog, null)}
                }
                Action {
                    text: 'Project homepage'
                    onTriggered: {Qt.openUrlExternally(client.projectUrl)}
                }
                Action {
                    text: 'Clear & reload station data'
                    onTriggered: {
                        stations.clearDatabase();
                        stations.loadStations();
                    }
                }
            }
        }

    }


    tools: ToolbarItems {
        ToolbarButton {
            id: actionsButton
            iconSource: Qt.resolvedUrl('image://theme/navigation-menu')
            text: 'Menu'
            onTriggered: PopupUtils.open(actionSelectionPopover, actionsButton)
        }
    }


}
