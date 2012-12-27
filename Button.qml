/*
    This file is part of Micro Soldier.

    Micro Soldier is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Micro Solider is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Micro Soldier.  If not, see <http://www.gnu.org/licenses/>.
  */
import QtQuick 1.1
import "GameState.js" as GameState

Rectangle {
    id: button
    width: 60; height: 55
    enabled: true
    color: "lime"

    property string txt: "value"
    Text{
        id: buttonLabel
        anchors.centerIn: parent
        text: txt
        font.pointSize: 12
    }
    onVisibleChanged: {
        console.debug("button: onVisibleChanged txt:" + txt)
    }

    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        onClicked: {
            console.log("buttonMouseArea clicked state=",state)
            if (txt === "Quit") {
                button.state = "END"
                gameMouseArea.stateX("QUIT")
            }
            else if (txt === "Surrender") {
                button.state = "END"
                gameMouseArea.stateX("SURRENDER")
            } else if (txt === "Lost" || txt === "Won") {
                // roll of honour
                mainWindow.state = "endMission"
//                menuUiVisibile(false)
                GameState.onLoaded()

            } else  {
                button.state = "PLAYING"
                button.visible = false
                gameMouseArea.stateX("PLAYING")
            }
        }
    }
    states: [
        State {
            name: "START"
            PropertyChanges { target: gameMouseArea; hoverEnabled: false }
        },
        State {
            name: "PLAYING"
            PropertyChanges { target: gameMouseArea; hoverEnabled: true }
        },
        State {
            name: "END"
            PropertyChanges { target: gameMouseArea; hoverEnabled: false }
        }
    ]
}

