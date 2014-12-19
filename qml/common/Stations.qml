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
import QtQuick.LocalStorage 2.0


Item {

    property string databaseName: 'fremantleline-stations'
    property string databaseVersion: '0.1'
    property string databaseDescription: ''
    property int busy: 0

    function clearDatabase() {
        busy += +1;
        var db = getDatabase();
        db.transaction(function (tx) {
            tx.executeSql('DROP TABLE IF EXISTS stations');
        });
        busy += -1;
    }

    function getDatabase() {
        var db = LocalStorage.openDatabaseSync(databaseName, databaseVersion, databaseDescription);
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS stations(url TEXT UNIQUE PRIMARY KEY, name TEXT UNIQUE, is_starred INTEGER NOT NULL DEFAULT 0)');
        });
        return db;
    }

    function loadStations() {
        busy += +1;
        application.stationList.clear();
        var db = getDatabase();
        db.transaction(function (tx) {
            var rs = tx.executeSql('SELECT * FROM stations ORDER BY is_starred DESC, name ASC;');
            if (rs.rows.length === 0) {
                client.saveStations();
            } else {
                for (var i=0; i < rs.rows.length; i++) {
                    var row = rs.rows.item(i);
                    application.stationList.append({'url': row.url, 'name': row.name, 'isStarred': row.is_starred ? true : false})
                }
            }
        });
        busy += -1;
    }

    function saveStation(url, name, isStarred) {
        busy += +1;
        isStarred = typeof isStarred != 'undefined' ? isStarred : false;
        var is_starred = isStarred ? 1 : 0 // Database uses integer values
        var db = getDatabase();
        db.transaction(function (tx) {
            tx.executeSql('INSERT OR REPLACE INTO stations VALUES(?, ?, ?)', [url, name, is_starred]);
        });
        busy += -1;
    }

    visible: false;

    Component.onCompleted: {
        loadStations();
    }

}
