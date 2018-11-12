// Fremantle Line: Transperth trains live departure information
// Copyright (c) 2009-2018 Matt Austin
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
        text: application.station ? application.station.name : 'Perth Trains'
        visible: application.departureList ? application.departureList.length < 1 : !application.departure
    }


    ListView {

        id: departureList

        property real headerHeight: Theme.itemSizeExtraSmall
        property real itemHeight: Theme.itemSizeExtraSmall

        clip: true
        interactive: false
        model: application.departureList
        height: 3*itemHeight + 3*Theme.paddingSmall + headerHeight
        width: parent.width - 2*x
        spacing: Theme.paddingSmall
        x: Theme.paddingLarge
        y: Theme.paddingMedium + Theme.paddingSmall
        visible: (!application.departure && application.departureList) ? application.departureList.length > 0 : false

        header: Label {
            width: parent.width
            text: application.station ? application.station.name + '\n' : 'Perth Trains\n'
            font.pixelSize: Theme.fontSizeExtraSmall
            lineHeight: 1.25/2
            truncationMode: TruncationMode.Fade
            Component.onCompleted: {
                departureList.headerHeight = height;
            }
        }

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

        enabled: application.station && !application.departure && !client.busy

        CoverAction {
            iconSource: 'image://theme/icon-cover-refresh'
            onTriggered: {
                application.getDepartures();
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
        visible: application.departure

        Column {

            width: parent.width

            Component.onCompleted: {
                departureInfo.itemHeight = height;
            }

            Label {
                width: parent.width
                text: application.station ? application.station.name : 'Perth Trains'
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
                enabled: application.departure ? !application.departure.is_cancelled : true
                width: parent.width
                text: application.departure ? application.departure.actual_time : ''
                font.pixelSize: Theme.fontSizeExtraLarge
                font.strikeout: !enabled
                truncationMode: TruncationMode.Fade
                maximumLineCount: 1
                opacity: enabled && 1 || 0.75
            }

            Label {
                enabled: application.departure ? !application.departure.is_cancelled : true
                width: parent.width
                text: application.departure ? (application.departure.pattern_code ? application.departure.destination_name + ' ' + application.departure.pattern_code : application.departure.destination_name) : ''
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                font.strikeout: !enabled
                truncationMode: TruncationMode.Fade
                opacity: enabled && 1 || 0.75
            }

            Label {
                enabled: application.departure ? !application.departure.is_cancelled : true
                width: parent.width
                text: application.departure ? (application.departure.platform_number ? 'Platform ' + application.departure.platform_number : '') : ''
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
