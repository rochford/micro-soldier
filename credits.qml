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
    id: rectangle1
    width: 400
    height: 400
    color: "black"
    property string creditsText:
        "MicroSoldier\n\nCopyright 2013\n\nby Tim Rochford\n\n";

    Timer {
        id:textScrollTimer
        interval: 50; running: true; repeat: true
        onTriggered: {
            creditText.y -= 4
            if (creditText.y < -200) {
                textScrollTimer.stop()
                mainWindow.state="menu"
                menuUiVisibile(true)
            }
        }
    }

    Text {
        id: creditText
        y: parent.height
        text: creditsText
        color: "#ece1e1"
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 22
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            mainWindow.state="menu"
            menuUiVisibile(true)
        }
    }
}
