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
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import io.thp.pyotherside 1.0


Page {

    id: stationPage
    property string projectUrl: ''
    title: 'Perth Trains'
    visible: false

    ActivityIndicator {
        anchors.centerIn: parent
        running: python.loading
    }

    ListView {

        id: stationList
        anchors.fill: parent

        delegate: ListItem.Standard {
            width: stationList.width
            text: modelData.name
            progression: true
            onClicked: {
                departurePage.station = modelData;
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
                    onTriggered: {Qt.openUrlExternally(stationPage.projectUrl)}
                }
            }
        }

    }


    tools: ToolbarItems {
        id: thingFoo
        ToolbarButton {
            id: actionsButton
            iconSource: Qt.resolvedUrl('image://theme/navigation-menu')
            text: 'Menu'
            onTriggered: PopupUtils.open(actionSelectionPopover, actionsButton)
        }
    }


    Python {

        id: python
        property bool loading: true

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../..').substr('file://'.length));
            addImportPath(Qt.resolvedUrl('../../fremantleline').substr('file://'.length));
            addImportPath(Qt.resolvedUrl('../../fremantleline/ui').substr('file://'.length));
            importModule('ui', function() {
                get_stations();
            });
            importModule('meta', function() {
                stationPage.projectUrl = evaluate('meta.PROJECT_URL');
            });
        }

        onError: {
            console.log('python error: ' + traceback);
        }

        function get_stations() {
            call('ui.pyotherside.get_stations', [], function(result) {
                stationList.model = result;
                loading = false;
            });
        }

    }

}
