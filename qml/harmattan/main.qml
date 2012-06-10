// Fremantle Line: Transperth trains live departure information
// Copyright (c) 2009-2012 Matt Austin
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

import QtQuick 1.1
import com.nokia.meego 1.0


PageStackWindow {
    id: rootWindow
    showStatusBar: screen.currentOrientation == Screen.Portrait
    initialPage: stationPage
    
    StationListPage {
      id: stationPage
    }
    
    DepartureListPage {
      id: departurePage
    }
    
    Menu {
        id: myMenu
        MenuLayout {
            MenuItem {
                text: "About"
                onClicked: {aboutDialog.open()}
            }
            MenuItem {
                text: "Project homepage"
                onClicked: {
                    Qt.openUrlExternally("http://projects.developer.nokia.com/perthtrains")
                }
            }
        }
    }
    
    AboutDialog {
        id: aboutDialog
    }
    
    Component.onCompleted: {
        //theme.inverted = true
    }
    
    function setDepartureModel(mod) {
        departurePage.model = mod;
    }
}

