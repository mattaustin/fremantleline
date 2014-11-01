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
import Sailfish.Silica 1.0


ApplicationWindow {

    allowedOrientations: Orientation.Portrait

    cover: Qt.resolvedUrl('CoverPage.qml')
    initialPage: stationPage

    StationListPage {
      id: stationPage
    }

    DepartureListPage {
      id: departurePage
    }

    AboutDialog {
        id: aboutDialog
    }

    DepartureDialog {
        id: departureDialog
    }

    Client {
        id: client
    }

    Stations {
        id: stations
    }

}
