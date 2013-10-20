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

    id: departurePage
    property variant station
    title: station ? station.name : 'Departures'
    visible: false

    ActivityIndicator {
        anchors.centerIn: parent
        //running: python.loading
    }

    ListView {

        id: departureList
        anchors.fill: parent

        delegate: ListItem.Subtitled {
            width: departureList.width
            text: modelData.destination
            subText: modelData.subtitle
            icon: UbuntuShape {
                color: '#16ac48'
                radius: 'small'
                implicitHeight: parent.height
                implicitWidth: units.gu(1)
            }
        }

        Scrollbar {
            flickableItem: departureList
        }

    }


    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                text: 'Refresh'
                //iconSource: Qt.resolvedUrl('icon.png')
                onTriggered: {}
            }
        }
        locked: true
        opened: true
    }


    Python {

        id: python
        property bool loading: true

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../..').substr('file://'.length));
            addImportPath(Qt.resolvedUrl('../../fremantleline/ui/sailfish').substr('file://'.length));
            //importModule('qt5', function() {});
            getDepartures()
        }

        onError: {
            console.log('python error: ' + traceback);
        }

        function getDepartures() {
            departureList.model = null;
            loading = true;
            //call('qt5.pyotherside.get_departures', [departurePage.station.name, departurePage.station.url], function(result) {
                var result = evaluate('[{"destination": "Destination {0}".format(x), "subtitle": "All stops"} for x in range(6)]');
                departureList.model = result;
                loading = false;
            //});
        }

    }

//    onStatusChanged: {
//        if (status == PageStatus.Activating) {
//            python.getDepartures();
//        }
//    }


}
