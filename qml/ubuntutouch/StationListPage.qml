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
import io.thp.pyotherside 1.0


Page {

    id: stationPage
    property string projectUrl: ''
    title: 'Perth Trains'

    ActivityIndicator {
        anchors.centerIn: parent
        running: python.loading
        //size: BusyIndicatorSize.Large
        //Behavior on opacity {}
    }

    ListView {

        id: stationList
        anchors.fill: parent

        delegate: ListItem.Standard {
            width: stationList.width
            text: modelData.name
            onClicked: {
                //departurePage.station = modelData;
                //pageStack.push(departurePage);
            }
        }

        Scrollbar {
            flickableItem: stationList
        }

    }


    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                text: 'About'
                //iconSource: Qt.resolvedUrl("icon.png")
                onTriggered: {pageStack.push(departurePage);}
            }
        }
        ToolbarButton {
            action: Action {
                text: 'Project homepage'
                //iconSource: Qt.resolvedUrl("icon.png")
                onTriggered: {Qt.openUrlExternally(stationPage.projectUrl)}
            }
        }
        locked: true
        opened: true
    }



    Python {

        id: python
        property bool loading: true

        Component.onCompleted: {
            addImportPath('/home/matt/fremantleline');
            addImportPath('/home/matt/fremantleline/fremantleline');
            addImportPath('/home/matt/fremantleline/fremantleline/ui/sailfish');
            importModule('qt5', function() {
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
            call('qt5.pyotherside.get_stations', [], function(result) {
                console.log(result);
                stationList.model = result;
                loading = false;
            });
        }

    }

}
