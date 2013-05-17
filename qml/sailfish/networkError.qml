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

import QtQuick 1.1
import Sailfish.Silica 1.0


ApplicationWindow {

    allowedOrientations: Orientation.Portrait

    initialPage: networkErrorPage

    cover: CoverBackground {
        CoverPlaceholder {
            text: 'Perth Trains'
        }
    }

    Page {
        id: networkErrorPage

        SilicaFlickable {

            anchors.fill: parent
            contentHeight: childrenRect.height

            Column {

                width: parent.width
                spacing: theme.paddingLarge

                PageHeader {
                    title: 'Perth Trains'
                }

                Label {
                    text: "You must be connected to the internet in order to obtain train departure times."
                    width: parent.width - theme.paddingLarge - theme.paddingLarge
                    x: theme.paddingLarge
                    wrapMode: Text.WordWrap
                    font.pixelSize: theme.fontSizeMedium
                }

            }

        }

    }

}
