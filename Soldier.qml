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
import Qt.labs.particles 1.0

Item {
    id: soldier;
    visible: false
    property string _dir: "east"
    property string name: ""
    property string image: "images/red/pE.PNG"
    property int rank: 0
    Text {
        id: nameText
        text: name
        font.weight: Font.bold
        font.pointSize: 12
        anchors.bottom: solderImage.top
    }

    Image {
        id:solderImage
        source:image
        sourceSize.height: 20
        sourceSize.width: 20
    }
    x: 30;
    y: 30;
    property int destX: 30
    property int destY: 30
    property bool shooting: false
    property bool dead: false
    function changeImage(dir) {
        if (dir === "north" && _dir === dir)
            image = 'images/red/pN.PNG'
        if (dir === "north" && _dir != dir)
            image = 'images/red/pN2.PNG'
        else if (dir === "south" && _dir === dir )
            image = 'images/red/pS.PNG'
        else if (dir === "south" && _dir != dir )
            image = 'images/red/pS2.PNG'
        else if (dir === "east" && _dir === dir)
            image = 'images/red/pE.PNG'
        else if (dir === "east" && _dir != dir)
            image = 'images/red/pE2.PNG'
        else if (dir === "west" && _dir === dir)
            image = 'images/red/pW.PNG'
        else if (dir === "west" && _dir != dir)
            image = 'images/red/pW2.PNG'
        _dir = dir
    }
    state: "alive"
    states: [
        State {
            name: "alive"
            PropertyChanges { target: soldier; image:"images/red/pW.PNG" }
            PropertyChanges { target: nameText; visible:true }
            PropertyChanges { target: soldier; dead:false }
        },
        State {
            name: "dead"
            PropertyChanges { target: soldier; shooting:false }
            PropertyChanges { target: nameText; visible:false }
            PropertyChanges { target: soldier; image:'images/red/pTackled.PNG' }
            PropertyChanges { target: soldier; dead:true }
        }
    ]
    onFocusChanged: {
        console.debug('onFocusedChanged')
    }
    function moveSoldier() {
        if (state === "dead")
            return
        if ((soldier.destX - soldier.x) > 0) {
            soldier.x += 1;
            soldier.changeImage("east")
        }
        else if ((soldier.destX - soldier.x) < 0) {
            soldier.x -= 1;
            soldier.changeImage("west")
        }
        if (soldier.destY - soldier.y > 0) {
            soldier.y += 1;
            soldier.changeImage("north")
        }
        else if (soldier.destY - soldier.y < 0) {
            soldier.y -= 1;
            soldier.changeImage("south")
        }
    }
}

