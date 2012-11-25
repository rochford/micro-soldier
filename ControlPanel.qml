/*
    This file is part of Micro Soldier.

    Foobar is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Foobar is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Micro Soldier.  If not, see <http://www.gnu.org/licenses/>.
  */
import QtQuick 1.1

Rectangle {
    id: controlPanel
    width: 60
    height: parent.height
    x: parent.width - 60
    color: "#ffffff"
    MouseArea {
        id: controlPanelMouseArea
        anchors.fill: parent
        onClicked: {
            console.debug("controlPanelMouseArea onClicked");
        }
    }
}
