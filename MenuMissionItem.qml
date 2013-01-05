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
    id: missionItemRect
    property string colour: "#aa6666"
    property string missionName: "Mission"
    property string newState: "play"
    property int mineCount: 0
    property int enemyCount: 0
    property int soldierCount: 0
    property bool locked: true

    width: 100
    height: 100
    color: "#382828"
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (!locked) {
                mainWindow.state = newState
                mainWindow.mineCount = mineCount
                mainWindow.enemyCount = enemyCount
                mainWindow.soldierCount = soldierCount
                menuUiVisibile(false)
                console.debug(activeFocus)
            }
        }
    }
    Image {
        id: missionImageBackground
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.height: 40
        sourceSize.width: 40
        source: "images/land.png"

    }
    Image {
        id: missionImageLocked
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.height: 32
        sourceSize.width: 32
        source: "images/locked.png"
        visible: locked ? true: false
    }

    Text {
        color: "#f5eaea"
        text: missionName
        wrapMode: Text.WordWrap
        font.bold: true
        font.pointSize: 9
        width: missionItemRect - 5
        styleColor: "#f3ecec"
        horizontalAlignment: Text.AlignHCenter
        anchors.top: missionImageBackground.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
