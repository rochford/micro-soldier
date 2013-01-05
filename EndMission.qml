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
    id: endMissionScene
    width: 400
    height: 400
    color: "black"

    Timer {
        id:textScrollTimer2
        interval: 50; running: true; repeat: true
        onTriggered: {
            endMissionListView.y -= 3
            if (endMissionListView.y < rollOfHonourText.height) {
                textScrollTimer2.stop()
                mainWindow.state="menu"
                menuUiVisibile(true)
            }
        }
    }

    Text {
        id: rollOfHonourText
        y: 0
        text: "Roll of honour"
        color: "#ece1e1"
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 22
    }
    Component {
        id: soldierDelegatex
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                id:solderRankImgx
                source:"images/ranks/" + rank+ ".png"
                sourceSize.height: 60
                sourceSize.width: 60
            }
            Text {
                id: soldierNamex
                color: "#ece1e1"
                text: name
                font.pixelSize: 32
            }
            Text {
                id: soldierNameAlive
                color: "#ece1e1"
                text: " R.I.P."
                visible: !alive
                font.pixelSize: 32
            }
        }

        }
    ListView {
        id: endMissionListView
        y: parent.height
        width: parent.width
        height: parent.height
        anchors.topMargin: 373
        model: missionSoldierModel
        delegate: soldierDelegatex
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            mainWindow.state="menu"
            menuUiVisibile(true)
        }
    }
}
