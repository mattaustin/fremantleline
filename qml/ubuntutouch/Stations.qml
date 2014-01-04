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
import io.thp.pyotherside 1.0


Item {

    property string databaseName: 'fremantleline-stations'
    property string databaseVersion: '0.1'
    property string databaseDescription: ''
    property ListModel model: ListModel {}
    property bool loading: true

    visible: false;

    Component.onCompleted: {
        loadStations();
    }

    function clearDatabase() {
        var db = getDatabase();
        db.transaction(function(tx) {
            tx.executeSql('DROP TABLE IF EXISTS stations');
        });
    }

    function getDatabase() {
        var db = LocalStorage.openDatabaseSync(databaseName, databaseVersion, databaseDescription);
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS stations(url TEXT UNIQUE PRIMARY KEY, name TEXT UNIQUE, is_starred INTEGER NOT NULL DEFAULT 0)');
        });
        return db;
    }

    function loadStations() {
        loading = true;
        model.clear();
        var db = getDatabase();
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM stations ORDER BY is_starred DESC, name ASC;');
            if (rs.rows.length == 0) {
                python.saveStations();
            } else {
                for (var i=0; i < rs.rows.length; ++i) {
                    var row = rs.rows.item(i);
                    model.append({'url': row.url, 'name': row.name, 'isStarred': row.is_starred ? true : false})
                }
                loading = false;
            }
        });
    }

    function saveStation(url, name, isStarred) {
        isStarred = typeof isStarred !== 'undefined' ? isStarred : false;
        var is_starred = isStarred ? 1 : 0 // Database uses integer values
        var db = getDatabase();
        db.transaction(function(tx) {
            tx.executeSql('INSERT OR REPLACE INTO stations VALUES(?, ?, ?)', [url, name, is_starred]);
        });
    }

    Python {

        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('..').substr('file://'.length));
            addImportPath(Qt.resolvedUrl('../fremantleline').substr('file://'.length));
            addImportPath(Qt.resolvedUrl('../fremantleline/ui').substr('file://'.length));
        }

        onError: {
            console.log('python error: ' + traceback);
        }

        function saveStations() {
            importModule('ui', function() {
                call('ui.pyotherside.get_stations', [], function(result) {
                    result.forEach(function(item) {
                        saveStation(item['url'], item['name']);
                    });
                    model.append({'url': item['url'], 'name': ['name'], 'isStarred': false});
                    loading = false;
                });
            });
        }

    }

}
