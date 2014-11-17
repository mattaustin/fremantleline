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
import QtQuick.Controls 1.1


Rectangle {

    id: application

    property var station: null
    property ListModel stationList: ListModel {}
    property var departure: null
    property var departureList: null

//    function getDepartures() {
//        departureList = null;
//        client.fetchDepartures(station, function (result) {
//            departureList = result;
//        });
//    }

    //title: 'Perth Trains'
    width: 480
    height: 600
    visible: true

//    onDepartureChanged: {
//        if (departure) {
//            PopupUtils.open(departureDialog, null, {'departure': departure});
//        }
//    }

//    onStationChanged: {
//        departureList = null;
//        if (station) {
//            getDepartures();
//            pageStack.push(Qt.resolvedUrl('DepartureListPage.qml'), {station: station})
//        }
//    }

    StackView {

        id: pageStack
        initialItem: Qt.resolvedUrl('StationListPage.qml')

//        Component.onCompleted: {
//            Theme.name = 'Ubuntu.Components.Themes.SuruGradient'
//            push(Qt.resolvedUrl('StationListPage.qml'))
//        }

    }

//    Component {
//        id: departureDialog
//        DepartureDialog {}
//    }

    Client {
        id: client
    }

    Stations {
        id: stations
    }

}
