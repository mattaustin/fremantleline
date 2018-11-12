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
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1


MainView {

    id: application

    property var station: null
    property ListModel stationList: ListModel {}
    property var departure: null
    property var departureList: null

    function getDepartures() {
        departureList = null;
        client.fetchDepartures(station, function (result) {
            departureList = result;
        });
    }

    width: units.gu(48)
    height: units.gu(60)

    onDepartureChanged: {
        if (departure) {
            PopupUtils.open(departureDialog, null, {'departure': departure});
        }
    }

    onStationChanged: {
        departureList = null;
        if (station) {
            getDepartures();
            pageStack.push(Qt.resolvedUrl('DepartureListPage.qml'), {station: station})
        }
    }

    PageStack {

        id: pageStack

        Component.onCompleted: {
            Theme.name = 'Ubuntu.Components.Themes.SuruGradient'
            push(Qt.resolvedUrl('StationListPage.qml'))
        }

    }

    Component {
        id: departureDialog
        DepartureDialog {}
    }

    Client {
        id: client
    }

    Stations {
        id: stations
    }

}
