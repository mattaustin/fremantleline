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
        visible: departurePage.status != PageStatus.Active && departureDialog.status != PageStatus.Active
    }


    CoverPlaceholder {
        text: departurePage.station ? departurePage.station.name : 'Perth Trains'
        visible: departurePage.status == PageStatus.Active && departureList.count < 1

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

            Component.onCompleted: {
                departureList.itemHeight = height;
            }

            Label {
                enabled: !modelData.is_cancelled
                width: parent.width
                text: modelData.actual_time
                font.strikeout: !enabled
                truncationMode: TruncationMode.Fade
                maximumLineCount: 1
                opacity: enabled && 1 || 0.75
            }

            Label {
                enabled: !modelData.is_cancelled
                width: parent.width
                text: modelData.pattern_code ? modelData.destination_name + ' ' + modelData.pattern_code : modelData.destination_name
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                font.strikeout: !enabled
                truncationMode: TruncationMode.Fade
                opacity: enabled && 1 || 0.75
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


    Item {

        id: departureInfo

        property real itemHeight: Theme.itemSizeExtraSmall

        clip: true
        height: 3*itemHeight + 2*Theme.paddingSmall
        width: parent.width - 2*x
        x: Theme.paddingLarge
        y: Theme.paddingMedium + Theme.paddingSmall
        visible: departureDialog.status == PageStatus.Active

        Column {

            width: parent.width

            Component.onCompleted: {
                departureInfo.itemHeight = height;
            }

            Label {
                width: parent.width
                text: departurePage.station ? departurePage.station.name : 'Perth Trains'
                //wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
                truncationMode: TruncationMode.Fade
            }

            Label {
                width: parent.width
                text: ''
                font.pixelSize: Theme.fontSizeLarge
            }

            Label {
                enabled: departureDialog.departure ? !departureDialog.departure.is_cancelled : true
                width: parent.width
                text: departureDialog.departure ? departureDialog.departure.actual_time : ''
                font.pixelSize: Theme.fontSizeExtraLarge
                font.strikeout: !enabled
                truncationMode: TruncationMode.Fade
                maximumLineCount: 1
                opacity: enabled && 1 || 0.75
            }

            Label {
                enabled: departureDialog.departure ? !departureDialog.departure.is_cancelled : true
                width: parent.width
                text: departureDialog.departure ? (departureDialog.departure.pattern_code ? departureDialog.departure.destination_name + ' ' + departureDialog.departure.pattern_code : departureDialog.departure.destination_name) : ''
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                font.strikeout: !enabled
                truncationMode: TruncationMode.Fade
                opacity: enabled && 1 || 0.75
            }

            Label {
                enabled: departureDialog.departure ? !departureDialog.departure.is_cancelled : true
                width: parent.width
                text: departureDialog.departure ? (departureDialog.departure.platform_number ? 'Platform ' + departureDialog.departure.platform_number : '') : ''
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                font.strikeout: !enabled
                truncationMode: TruncationMode.Fade
                opacity: enabled && 1 || 0.75
            }

        }

    }


    Image {
        source: Qt.resolvedUrl('CoverBackground.png')
        opacity: 0.1
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: sourceSize.height * width / sourceSize.width
    }

}
