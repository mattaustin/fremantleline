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

    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../..').substr('file://'.length));
        setMeta();
    }

    onError: {
        console.log('python error: ' + traceback);
    }

    function setMeta() {
        importModule('fremantleline.meta', function () {
            projectUrl = evaluate('fremantleline.meta.PROJECT_URL');
            version = evaluate('fremantleline.meta.VERSION');
        });
    }

    function getDepartures(station) {
        importModule('fremantleline.ui', function () {
            departurePage.model = null;
            if (station) {
                busy += +1;
                call('fremantleline.ui.pyotherside.get_departures', [station.name, station.url], function (result) {
                    departurePage.model = result;
                    busy += -1;
                });
            }
        });
    }

    function saveStations() {
        addImportPath(Qt.resolvedUrl('../..').substr('file://'.length));
        importModule('fremantleline.ui', function () {
            busy += +1;
            call('fremantleline.ui.pyotherside.get_stations', [], function (result) {
                result.forEach(function (item) {
                    stations.saveStation(item['url'], item['name']);
                    stations.model.append({'url': item['url'], 'name': item['name'], 'isStarred': false});
                });
                busy += -1;
            });
        });
    }

}
