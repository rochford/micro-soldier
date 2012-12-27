/*
    This file is part of Micro Soldier.

    Micro Soldier is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Micro Soldier is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Micro Soldier.  If not, see <http://www.gnu.org/licenses/>.
  */
import QtQuick 1.1

Rectangle {
    width: 400
    height: 400
    color: "black"

    Text {
        id: helpText
        x: 0
        y: 0
        width: 400
        height: 400
        color: "#ffffff"
        text: qsTr("Each soldier is moved individually. Click the mouse to move to the mouse cursor position. Press space to shoot at the mouse position. Select the soldier from the control panel on the right. Soldiers die by stepping on mines or by being shot. The mission ends if a civillian is shot.")
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.pixelSize: 17
    }

    MouseArea {
        id: mousearea1
        anchors.fill: parent
        onClicked: {
            mainWindow.state="menu"
            menuUiVisibile(true)
        }
    }
}
