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
import Qt.labs.particles 1.0

Item {
    id: soldier;
    visible: false
    property string name: ""
    property string image: "images/red/pE.PNG"
    property int rank: 1
    // KIA - killed in action, MIA - Missing in Action
    property string status: "K.I.A."
    Text {
        id: nameText
        text: name
        font.pointSize: 12
        anchors.bottom: soldierImage.top
    }

    Image {
        id:solderRankImage
        source:"images/ranks/" + rank + ".png"
        sourceSize.height: 20
        sourceSize.width: 20
        anchors.top: soldierImage.bottom
    }
    Sprite {
        id:soldierImage
        width: 30;height: 30
        source: image
        running: false
        frameCount: 3
    }
    x: 30;
    y: 30;
    property int destX: 30
    property int destY: 30
    property bool shooting: false
    property bool dead: false
    function changeImage(dir) {
        soldierImage.running = true
        image = "images/red/"+ dir + ".png"
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
            PropertyChanges { target: soldierImage; running:false }
            PropertyChanges { target: soldierImage; source:'images/red/pTackled.PNG' }
            PropertyChanges { target: soldierImage; frame:0 }
            PropertyChanges { target: soldierImage; frameCount:1 }
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
        if ((soldier.destX - soldier.x) < 0 &&
                 (soldier.destY - soldier.y) > 0) {
            soldier.x -= 1;
            soldier.y += 1
            soldier.changeImage("northwest")
        }
        else if ((soldier.destX - soldier.x) < 0 &&
                 (soldier.destY - soldier.y) < 0) {
            soldier.x -= 1;
            soldier.y -= 1
            soldier.changeImage("southwest")
        }
        else if ((soldier.destX - soldier.x) > 0 &&
                 (soldier.destY - soldier.y) > 0) {
            soldier.x += 1;
            soldier.y += 1
            soldier.changeImage("northeast")
        }
        else if ((soldier.destX - soldier.x) < 0 &&
                 (soldier.destY - soldier.y) > 0) {
            soldier.x -= 1;
            soldier.y += 1
            soldier.changeImage("northwest")
        }
        else if ((soldier.destX - soldier.x) > 0) {
            soldier.x += 1;
            soldier.changeImage("east")
        }
        else if ((soldier.destX - soldier.x) < 0) {
            soldier.x -= 1;
            soldier.changeImage("west")
        }
        if (soldier.destY - soldier.y > 0) {
            soldier.y += 1;
            soldier.changeImage("south")
        }
        else if (soldier.destY - soldier.y < 0) {
            soldier.y -= 1;
            soldier.changeImage("north")
        }
    }
}

