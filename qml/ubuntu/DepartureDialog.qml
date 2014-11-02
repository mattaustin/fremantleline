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
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1


Component {

    Dialog {

        id: dialog

        property var departure

        title: departure.actual_time + ' to ' + departure.destination_name
        text: (departure.pattern_code ? departure.pattern_code + ' pattern' : 'All stops') + '\n\n' + departure.pattern_description

        Button {
            gradient: UbuntuColors.greyGradient
            onClicked: PopupUtils.close(dialog)
            text: 'Close'
        }

    }

}
