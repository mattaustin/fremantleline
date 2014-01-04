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


CoverBackground {

    CoverPlaceholder {
        text: 'Perth Trains'
        visible: departurePage.status != PageStatus.Active
    }


    ListView {

        id: departureList

        property real itemHeight: Theme.itemSizeExtraSmall

        clip: true
        interactive: false
        model: departurePage.model
        height: 3*itemHeight + 2*Theme.paddingSmall
        width: parent.width - 2*x
        spacing: Theme.paddingSmall
        x: Theme.paddingLarge
        y: Theme.paddingMedium + Theme.paddingSmall
        visible: departurePage.status == PageStatus.Active

        delegate: Column {

            width: parent.width

            Component.onCompleted:
                {departureList.itemHeight = height;
            }

            Item {
                width: parent.width
                height: Theme.paddingSmall
            }

            Label {
                width: parent.width
                text: modelData.time
                truncationMode: TruncationMode.Fade
                maximumLineCount: 1
            }

            Label {
                opacity: 0.6
                width: parent.width
                text: modelData.destination
                truncationMode: TruncationMode.Fade
                font.pixelSize: Theme.fontSizeExtraSmall
            }

        }

    }


    CoverActionList {

        enabled: departurePage.status == PageStatus.Active

        CoverAction {
            iconSource: 'image://theme/icon-cover-refresh'
            onTriggered: {
                departurePage.refresh();
            }
        }

    }


}
