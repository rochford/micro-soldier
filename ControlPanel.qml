/*
    This file is part of Micro Soldier.

    Micro Solider is free software: you can redistribute it and/or modify
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

Rectangle {
    id: controlPanel
    width: 60
    height: parent.height
    x: parent.width - controlPanel.width
    color: "green"

    Component {
        id: soldierDelegate
        Column {
            Image {
                id: solderImg
                source: soldiers.itemAt(index).image
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (soldiers.itemAt(index).state != "dead") {
                            //foo.source = soldiers.itemAt(index).solderImage.source
                            soldierName.text = soldiers.itemAt(index).name
                            console.debug("", soldiers.itemAt(index).name)
                            moveDestination.visible = false
                            focusedSolider = index
                            console.debug("focusedSoldier = ", index);
                        }
                    }
                }
            }
            Text {
                id: soldierName
                text: soldiers.itemAt(index).name
            }
            Image {
                id:solderRankImg
                source:"images/ranks/" + soldiers.itemAt(index).rank + ".png"
                sourceSize.height: 20
                sourceSize.width: 20
            }
        }
    }
    ListView {
        anchors.fill: parent
        model: missionSoldierModel
        delegate: soldierDelegate
    }
}
