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

Rectangle {
    id:gameScene
    width: 400
    height: 400
    state: "START"
    Image {
        id: land
        height: parent.height
        width: parent.width - 60
        source: 'images/land.png'
        anchors.centerIn: parent
    }
    ControlPanel {
        Button {
            id: endButton
            txt: "Quit"
            color: "lime"
            visible: false
            anchors {
                top: parent.top
                left: parent.left
            }
            state: "START"
            states: [
                State {
                    name: "START"
                    PropertyChanges { target: endButton; visible:false}
                },
                State {
                    name: "PLAYING"
                    PropertyChanges { target: endButton; txt:"Quit XXX"}
                    PropertyChanges { target: endButton; visible:true}
                }
            ]
            onStateChanged: {
                console.debug( "endButton("+ txt + ")" + state )
            }
        }
    }

    states: [
        State {
            name: "START"
            PropertyChanges { target: startButton; visible: true}
            PropertyChanges { target: endButton; visible: false}
            PropertyChanges { target: gameScene; color:"red"}
        },
        State {
            name: "PLAYING"
            PropertyChanges { target: startButton; visible: false}
            PropertyChanges { target: endButton; visible: true}
            PropertyChanges { target: gameScene; color:"green"}
            PropertyChanges { target: gameScene; color:"lime"}
        },
        State {
            name: "END"
            PropertyChanges { target: startButton; visible: true}
            PropertyChanges { target: endButton; visible: false}
            PropertyChanges { target: gameScene; color:"blue"}
        }
    ]
    property string gameOverTextLiteral:'Mission Failed'
    property string gameOverTextWonLiteral:'Mission Accomplished'
    property int shootRange: 140

    function gameInitialze()
    {
        gameMouseArea.enabled= true
        soldier.visible= true
        soldier.state = "alive"
        soldier.x = Math.floor((Math.random()*land.width)%land.width)
        soldier.y = Math.floor((Math.random()*land.height)%land.height)
        gameTimer.gameWon = false
        moveDestination.visible = false
        bullet.visible = false
        bulletTimer.stop()
        for (var i=0; i<n2.count; i++) {
            n2.itemAt(i).state = "alive"
            n2.itemAt(i).visible = true
        }
        gameTimer.start();
        endButton.state = "PLAYING"
    }

    function dead(e, x, y) {
        if (((e.x > (x-10) ) && e.x < (x+10)) && ((e.y > (y-10) ) && e.y < (y+10)))
            return true;
        else
            return false;
    }

    function check_mine_explode(e, x, y) {
        if (((e.x > (x-10) ) && e.x < (x+10)) && ((e.y > (y-10) ) && e.y < (y+10)))
            return true;
        else
            return false;
    }
    function shoot(x, y) {
        console.debug("shoot ",x, y)

        // check that the distance is not too far
        var minX = soldier.x - shootRange
        var maxX = soldier.x + shootRange
        var minY = soldier.y - shootRange
        var maxY = soldier.y + shootRange
        if ( (minX < x) && (x < maxX)
                && (minY < y) && (y < maxY) ) {
            bullet.x = x
            bullet.y = y
            bullet.visible = true;
            bulletTimer.start()
            for (var i=0; i<n2.count; i++) {
                if (dead(n2.itemAt(i),x,y))
                    n2.itemAt(i).state = "dead";
            }
            for (var i=0; i<mine_repeater.count; i++) {
                if (check_mine_explode(mine_repeater.itemAt(i),x,y))
                    mine_repeater.itemAt(i).state = "exploded";
            }
        }
    }

    function moveEvil(e) {
//        console.debug("MoveEvil " + e.x +","+ e.y)
        if (e.state != "alive")
            return;
        if ((soldier.x - e.x) > 0) {
            e.x += 1;
            e.changeImage("east")
        }
        else if ((soldier.x - e.x) < 0) {
            e.x -= 1;
            e.changeImage("west")
        }
        if ((soldier.y - e.y) > 0) {
            e.y += 1;
            e.changeImage("north")
        }
        else if ((soldier.y - e.y) < 0) {
            e.y -= 1;
            e.changeImage("south")
        }
    }
    focus: true
    Keys.onPressed: {
        if (event.key === Qt.Key_Space) {
            event.accepted = true;
            soldier.shooting = true;
       }
    }
    Keys.onReleased: {
        if (event.key === Qt.Key_Space) {
        //    event.accepted = true;
            soldier.shooting = false;
       }
    }

    Timer {
        id:bulletTimer
        interval: 50; running: false; repeat: false
        onTriggered: {
            console.debug("Bullet timer triggered")
            if (bullet.visible)
                bullet.visible = false;
        }
    }

    Item {
        id:bullet
        visible: false
        Image {
            source:"images/bullet.png"
            sourceSize.height: 20
            sourceSize.width: 20
        }
        x: 120;
        y: 120;
    }

    MoveDestination {
        id:moveDestination
    }

    Timer {
        id:gameTimer
        interval: 70; running: false; repeat: true
        property bool gameWon: false;
        property bool enemiesDead: false;
        onTriggered: {
            enemiesDead= true
            for (var i=0; i<n2.count; i++) {
                if ( n2.itemAt(i).state === "alive")
                    enemiesDead=false
            }
            if (soldier.x === moveDestination.x &&
                soldier.y === moveDestination.y) {
                moveDestination.visible= false
            }

            if (soldier.state === "dead") {
                console.debug("Lost")
                startButton.visible = true
                startButton.txt = "Lost"
                startButton.state= "END"
                gameTimer.gameWon = false
                gameTimer.stop()
                gameScene.state="END"
                return
            }

            if (enemiesDead) {
                gameTimer.gameWon = true
                gameScene.state= "END"
                startButton.txt = "Won"
                startButton.visible = true
                startButton.state = "END"
            }
            if (gameWon) {
                gameTimer.stop();
                gameScene.state= "END"
                return
            }
            if ((soldier.destX - soldier.x) > 0) {
                soldier.x += 1;
                soldier.changeImage("east")
            }
            else if ((soldier.destX - soldier.x) < 0) {
                soldier.x -= 1;
                soldier.changeImage("west")
            }
            if ((soldier.destY - soldier.y) > 0) {
                soldier.y += 1;
                soldier.changeImage("north")
            }
            else if ((soldier.destY - soldier.y) < 0) {
                soldier.y -= 1;
                soldier.changeImage("south")
            }
            for (var j=0; i< mine_repeater.count; i++) {
                if ( mine_repeater.itemAt(j).state === "active") {
                    var minX = mine_repeater.itemAt(j).x - mines.proxmity
                    var maxX = mine_repeater.itemAt(j).x + mines.proxmity
                    var minY = mine_repeater.itemAt(j).y - mines.proxmity
                    var maxY = mine_repeater.itemAt(j).y + mines.proxmity
                    if ( (minX <  soldier.x) && (soldier.x < maxX) &&
                         (minY <  soldier.y) && (soldier.y < maxY) )
                        {
                        console.debug("stepped on mine")
                        mine_repeater.itemAt(j).state = "exploded"
                        startButton.visible = true
                        startButton.txt = "Lost"
                        startButton.state = "END"
                        gameTimer.stop();
                        gameScene.state= "END"
                        return
                        }
                }
            }
            for (var j=0; j<n2.count; j++) {
//                console.debug("move Evil, n2.count=" + n2.count + ", state=" + n2.itemAt(j).state);
                moveEvil(n2.itemAt(j));
                // are they able to shoot the soldier?
                // check that the distance is not too far
                var range = 40
                var minX = soldier.x - range
                var maxX = soldier.x + range
                var minY = soldier.y - range
                var maxY = soldier.y + range
                if ( (minX < n2.itemAt(j).x) && (n2.itemAt(j).x < maxX)
                        && (minY < n2.itemAt(j).y) && (n2.itemAt(j).y < maxY) ) {
                    // dead
                    soldier.state = "dead"
                }
            }
        }
    }

    Item {
        id: soldier;
        visible: false
        property string _dir: "east"
        Image {
            id:solderImage
            source:"images/red/pE.PNG"
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
                solderImage.source = 'images/red/pN.PNG'
            if (dir === "north" && _dir != dir)
                solderImage.source = 'images/red/pN2.PNG'
            else if (dir === "south" && _dir === dir )
                solderImage.source = 'images/red/pS.PNG'
            else if (dir === "south" && _dir != dir )
                solderImage.source = 'images/red/pS2.PNG'
            else if (dir === "east" && _dir === dir)
                solderImage.source = 'images/red/pE.PNG'
            else if (dir === "east" && _dir != dir)
                solderImage.source = 'images/red/pE2.PNG'
            else if (dir === "west" && _dir === dir)
                solderImage.source = 'images/red/pW.PNG'
            else if (dir === "west" && _dir != dir)
                solderImage.source = 'images/red/pW2.PNG'
            _dir = dir
        }
        state: "alive"
        states: [
            State {
                name: "alive"
                PropertyChanges { target: solderImage; source:"images/red/pW.PNG" }
            },
            State {
                name: "dead"
                PropertyChanges { target: soldier; shooting:false }
                PropertyChanges { target: solderImage; source:'images/red/tackleN.PNG' }
            }
        ]
    }

    Row {
        id: mines
        property int  proxmity: 20
        Repeater {
            id:mine_repeater
            model: 30
            Mine {

            }
        }
    }
    Row {
        id: n1
        Repeater {
            id:n2
            model: 2
            Item {
                id: e3;
                x: Math.floor((Math.random()*land.width)%land.width)
                y: Math.floor((Math.random()*land.height)%land.height)
                property int destX: 30
                property int destY: 30
                property url enemyImage: "images/red/tackleS.PNG"
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
                        enemyImage3.source = 'images/red/pN.PNG'
                    else if (dir === "south")
                        enemyImage3.source = 'images/red/pS.PNG'
                    else if (dir === "east")
                        enemyImage3.source = 'images/red/pE.PNG'
                    else if (dir === "west")
                        enemyImage3.source = 'images/red/pW.PNG'
                }
                state: "alive"
                states: [
                    State {
                        name: "alive"
                        PropertyChanges { target: enemyImage3; source:"images/red/pW.PNG" }
                    },
                    State {
                        name: "dead"
                        StateChangeScript { script: particles.burst(4); }
                        PropertyChanges { target: e3; shooting:false }
                        PropertyChanges { target: enemyImage3; source:'images/red/tackleN.PNG' }
                    }
                ]
            }
        }
    }

    MouseArea {
        id: gameMouseArea
        signal stateX (string statex)
        onStateX: {
            if (statex === "PLAYING") {
                gameInitialze();
                gameScene.state = "PLAYING"
            }
            if (statex === "QUIT") {
                startButton.visible = true
                startButton.txt = "Lost"
                startButton.state= "END"
                gameTimer.stop();
                gameScene.state = "END"
            }
        }

        anchors.fill: land
        onPositionChanged: {
            if ( soldier.shooting ) {
                shoot(mouseX, mouseY)
            }
        }

        onClicked: {
            if(gameScene.state === "PLAYING") {
                if ( soldier.shooting ) {
                    shoot(mouseX, mouseY)
                } else {
                    console.debug("gameMouseArea onClicked")

                    // is x,y inside the land?
                    if ( (land.x < mouseX) && (mouseX < land.width)
                            && (land.y < mouseY) && (mouseY < land.height) ) {
                        soldier.destX = mouseX
                        soldier.destY = mouseY
                        moveDestination.x = mouseX;
                        moveDestination.y = mouseY;
                        moveDestination.visible = true;
                    }
                }
            }
        }

    }
    Button {
        id: startButton
        txt: "Press to start"
        width: 120
        color: "lime"
        anchors.centerIn: parent
        state: "START"
        states: [
            State {
                name: "START"
                PropertyChanges { target: startButton; visible:true;}
                PropertyChanges { target: startButton; txt:"Press to start"}
                PropertyChanges { target: gameMouseArea; hoverEnabled: false }
            },
            State {
                name: "PLAYING"
                PropertyChanges { target: startButton; visible:false;}
                PropertyChanges { target: gameMouseArea; hoverEnabled: true }
            },
            State {
                name: "END"
                PropertyChanges { target: startButton; visible:true;}
                PropertyChanges { target: startButton; txt:"Game Over XXX"}
                PropertyChanges { target: gameMouseArea; hoverEnabled: false }
            }
        ]
    }
}
