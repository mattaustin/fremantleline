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
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.0


Page {

    id: stationPage
    property string projectUrl: ''

    BusyIndicator {
        anchors.centerIn: parent
        running: python.loading
        size: BusyIndicatorSize.Large
        Behavior on opacity {}
    }

    SilicaListView {

        id: stationList
        anchors.fill: parent

        header: PageHeader {
            title: 'Perth Trains'
        }

        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: 'About'
                onClicked: {
                    pullDownMenu.close();
                    aboutDialog.open();
                }
            }
            MenuItem {
                text: 'Project homepage'
                onClicked: {Qt.openUrlExternally(stationPage.projectUrl)}
            }
        }

        delegate: BackgroundItem {
            width: stationList.width
            Label {
                text: modelData.name
                color: parent.down ? Theme.highlightColor : Theme.primaryColor
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.paddingLarge
            }
            onClicked: {
                departurePage.station = modelData;
                pageStack.push(departurePage);
            }
        }

        VerticalScrollDecorator {}

    }


    Python {

        id: python
        property bool loading: true

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../..').substr('file://'.length));
            addImportPath(Qt.resolvedUrl('../../fremantleline').substr('file://'.length));
            addImportPath(Qt.resolvedUrl('../../fremantleline/ui/sailfish').substr('file://'.length));
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
                stationList.model = result;
                loading = false;
            });
        }

    }

}
