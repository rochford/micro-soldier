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
        color: "green"
        MouseArea {
            id: controlPanelMouseArea
            anchors.fill: parent
            onClicked: {
                console.debug("controlPanelMouseArea onClicked");
            }
        }
    Column {
        anchors.bottom: controlPanel.bottom
        Repeater {
            id: array
            model: soldiers.count
            Item {
                height: controlPanel.width
                width: controlPanel.width
                Image {
                    id: foo
                    //                    anchors.bottom: soldiers.bottom
                    source: "images/red/pS.PNG" //soldiers.itemAt(0).solderImage.source
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            focusedSolider = index
                            console.debug("focusedSoldier = ", index);
                        }
                    }
                }
                Text {
                    text: names[index]
                    anchors.top: foo.bottom
                }
            }

        }
    }
}
