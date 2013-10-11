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

Item {

    anchors.fill: parent

    Label {
        text: departurePage.status == PageStatus.Active ? departurePage.station.name : 'Perth Trains'
        anchors.centerIn: parent
        width: parent.width - 2*Theme.paddingLarge
        color: Theme.secondaryColor
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        truncationMode: TruncationMode.Fade
        font.pixelSize: Theme.fontSizeSmall
    }

}
