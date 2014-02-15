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


Page {

    id: dialog
    property var departure
    forwardNavigation: false


    SilicaFlickable {

        anchors.fill: parent
        contentHeight: childrenRect.height

        Column {

            width: dialog.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: departure ? departure.actual_time + ' to ' + departure.destination_name : ''
            }

            Label {
                text: departure ? departure.pattern_code && departure.pattern_code + ' pattern' || 'All stops' : ''
                color: Theme.highlightColor
                width: parent.width - Theme.paddingLarge - Theme.paddingLarge
                x: Theme.paddingLarge
                wrapMode: Text.WordWrap
                font.family: Theme.fontFamilyHeading
                font.pixelSize: Theme.fontSizeMedium
            }

            Label {
                text: departure ? departure.pattern_description : ''
                color: Theme.highlightColor
                width: parent.width - Theme.paddingLarge - Theme.paddingLarge
                x: Theme.paddingLarge
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeMedium
            }

        }

    }


    function open() {
        pageStack.push(dialog);
    }


}
