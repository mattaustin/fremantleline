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
import io.thp.pyotherside 1.2


Python {

    property int busy: 0
    property string projectUrl: ''
    property string version: ''

    function fetchDepartures(station, callback) {
        busy += +1;
        importModule('fremantleline.ui', function () {
            call('fremantleline.ui.pyotherside.get_departures', [station.name, station.url], function (result) {
                typeof callback === 'function' && callback(result);
                busy += -1;
            });
        });
    }

    function saveStations() {
        addImportPath(Qt.resolvedUrl('..'));
        addImportPath(Qt.resolvedUrl('../..'));
        importModule('fremantleline.ui', function () {
            busy += +1;
            call('fremantleline.ui.pyotherside.get_stations', [], function (result) {
                result.forEach(function (station) {
                    stations.saveStation(station.url, station.name);
                    application.stationList.append({'url': station.url, 'name': station.name, 'isStarred': false});
                });
                busy += -1;
            });
        });
    }

    function setMeta() {
        importModule('fremantleline.meta', function () {
            projectUrl = evaluate('fremantleline.meta.PROJECT_URL');
            version = evaluate('fremantleline.meta.VERSION');
        });
    }

    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('..'));
        addImportPath(Qt.resolvedUrl('../..'));
        setMeta();
    }

    onError: {
        console.log('Python error: ' + traceback);
    }

}
