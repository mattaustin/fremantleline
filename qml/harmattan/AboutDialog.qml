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
import com.nokia.meego 1.0


QueryDialog {
    titleText: 'About Fremantle Line v' + version
    message: 'Copyright (c) 2009-2013 Matt Austin.\n\nFremantle Line (\"Perth Trains\") is free sofware licenced under the GNU Public License version 3.\n\nData is provided on an \"as is\" and \"as available\" basis. No representations or warranties of any kind, express or implied are made. Data is available free of charge from www.transperth.wa.gov.au. This program accesses data using your internet connection. Your operator may charge you for data use.'
    rejectButtonText: 'Close'
}

