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
    id: e3;
    x: Math.floor((Math.random()*land.width)%land.width)
    y: Math.floor((Math.random()*land.height)%land.height)
    property int destX: 30
    property int destY: 30
    property url enemyImage: "images/enemy/tackleS.PNG"
    property bool shooting: false
    Particles {
        id: particles

        width: 2; height: 3
        anchors.centerIn: parent

        emissionRate: 0
        lifeSpan: 500; lifeSpanDeviation: 100
        angle: 0; angleDeviation: 360;
        velocity: 20; velocityDeviation: 10
        source:"images/dead_enemy.png"
    }
    Image {
        id:enemyImage3
        source:enemyImage
        sourceSize.height: 20
        sourceSize.width: 20
        }
    function changeImage(dir) {
        if (dir === "north")
            enemyImage3.source = 'images/enemy/pN.PNG'
        else if (dir === "northeast")
            enemyImage3.source = 'images/enemy/pNE.PNG'
        else if (dir === "northwest")
            enemyImage3.source = 'images/enemy/pNW.PNG'
        else if (dir === "south")
            enemyImage3.source = 'images/enemy/pS.PNG'
        else if (dir === "southeast")
            enemyImage3.source = 'images/enemy/pSE.PNG'
        else if (dir === "southwest")
            enemyImage3.source = 'images/enemy/pSW.PNG'
        else if (dir === "east")
            enemyImage3.source = 'images/enemy/pE.PNG'
        else if (dir === "west")
            enemyImage3.source = 'images/enemy/pW.PNG'
    }
    state: "alive"
    states: [
        State {
            name: "alive"
            PropertyChanges { target: enemyImage3; source:"images/enemy/pW.PNG" }
        },
        State {
            name: "dead"
            StateChangeScript { script: particles.burst(4); }
            PropertyChanges { target: e3; shooting:false }
            PropertyChanges { target: enemyImage3; source:'images/enemy/pTackled.PNG' }
        }
    ]

    function moveEvil(e) {
        var indx= -1
//        console.debug("MoveEvil " + e.x +","+ e.y)
        if (e3.state != "alive")
            return;
        var distX = 1000;
        var distY = 1000;
        for (var i=0; i<soldiers.count; i++) {
            if (soldiers.itemAt(i).state != "dead") {
                // if the distance is less, then select the closer soldier
                var deltaX = Math.abs(soldiers.itemAt(i).x - e3.x);
                var deltaY = Math.abs(soldiers.itemAt(i).y - e3.y);
                if ( ( distX > deltaX ) && ( distY > deltaY ) ) {
                    indx=i
                    distX = deltaX;
                    distY = deltaY;
                }
            }
        }
        if (indx === -1)
            return;

        if ((soldiers.itemAt(indx).x - e3.x) > 0) {
            e3.x += 1;
            e3.changeImage("east")
        }
        else if ((soldiers.itemAt(indx).x - e3.x) < 0 &&
                 (soldiers.itemAt(indx).y - e3.y) > 0) {
            e3.x -= 1;
            e3.y += 1
            e3.changeImage("northwest")
        }
        else if ((soldiers.itemAt(indx).x - e3.x) < 0 &&
                 (soldiers.itemAt(indx).y - e3.y) < 0) {
            e3.x -= 1;
            e3.y -= 1
            e3.changeImage("southwest")
        }
        else if ((soldiers.itemAt(indx).x - e3.x) > 0 &&
                 (soldiers.itemAt(indx).y - e3.y) > 0) {
            e3.x += 1;
            e3.y += 1
            e3.changeImage("northeast")
        }
        else if ((soldiers.itemAt(indx).x - e3.x) < 0 &&
                 (soldiers.itemAt(indx).y - e3.y) > 0) {
            e3.x -= 1;
            e3.y += 1
            e3.changeImage("northwest")
        }
        else if ((soldiers.itemAt(indx).x - e3.x) < 0) {
            e3.x -= 1;
            e3.changeImage("west")
        }
        if ((soldiers.itemAt(indx).y - e3.y) > 0) {
            e3.y += 1;
            e3.changeImage("north")
        }
        else if ((soldiers.itemAt(indx).y - e3.y) < 0) {
            e3.y -= 1;
            e3.changeImage("south")
        }
    }

}


