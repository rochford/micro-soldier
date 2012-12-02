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
    id: button
    width: 60; height: 55
    enabled: true

    property string txt: "value"
    Text{
        id: buttonLabel
        anchors.centerIn: parent
        text: txt
        font.weight: Font.bold
        font.pointSize: 12
    }
    onVisibleChanged: {
        console.debug("button: onVisibleChanged txt:" + txt)
    }

    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        onClicked: {
            console.log("buttonMouseArea clicked")
            if (txt === "Quit") {
                button.state = "END"
                gameMouseArea.stateX("QUIT")
            }
            if (txt === "Surrender") {
                button.state = "END"
                gameMouseArea.stateX("SURRENDER")
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

