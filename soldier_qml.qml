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
    property variant names: [ 'Adam', 'Bob', 'Charlie', 'David', 'Eddy', 'Frank', 'George', 'Harry', 'Ian', 'Jerry', 'Ken' ]
    ListModel {
        id: soldierModel
    }

    id:gameScene
    width: 400
    height: 400
    state: "START"

    Image {
        id: land
        width: 340
        height: 400
        source: 'images/land.png'
    }
    ControlPanel {
        id: controlPanel
        Button {
            id: endButton
            txt: "Quit"
            color: "lime"
            //enabled: false
            anchors {
                bottom: parent.bottom
                left: parent.left
            }
            state: "START"
            states: [
                State {
                    name: "START"
                    PropertyChanges { target: endButton; txt:"Quit"}
                },
                State {
                    name: "PLAYING"
                    PropertyChanges { target: endButton; txt:"Surrender"}
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
            PropertyChanges { target: endButton; txt:"Quit"}
            PropertyChanges { target: gameScene; color:"red"}
        },
        State {
            name: "PLAYING"
            PropertyChanges { target: startButton; visible: false}
            PropertyChanges { target: endButton; txt:"Surrender"}
            PropertyChanges { target: gameScene; color:"green"}
            PropertyChanges { target: gameScene; color:"lime"}
        },
        State {
            name: "END"
            PropertyChanges { target: startButton; visible: true}
            PropertyChanges { target: endButton; txt:"Quit"}
            PropertyChanges { target: gameScene; color:"blue"}
        }
    ]
    property string gameOverTextLiteral:'Mission Failed'
    property string gameOverTextWonLiteral:'Mission Accomplished'
    property int shootRange: 140

    function gameInitialze()
    {
        soldierModel.clear()
        gameFinishedDelay.stop()
        gameMouseArea.enabled= true
        gameTimer.gameWon = false
        moveDestination.visible = false
        bullet.visible = false
        bulletTimer.stop()
        for (var i=0; i<n2.count; i++) {
            n2.itemAt(i).state = "alive"
        }
        for (var i=0; i<civilian_repeater.count; i++) {
            civilian_repeater.itemAt(i).state = "alive"
        }
        for (var i=0; i<soldiers.count; i++) {
            soldiers.itemAt(i).name = names[i]
            soldiers.itemAt(i).state = "alive"
            soldiers.itemAt(i).visible= true
            soldiers.itemAt(i).x = Math.floor((Math.random()*land.width)%land.width)
            soldiers.itemAt(i).y = Math.floor((Math.random()*land.height)%land.height)
            soldierModel.append({"name":names[i], "image":'images/red/pN.pNG' })
            console.debug('gameInitialize soldier')
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
//        console.debug("shoot ",x, y)
        if (gameFinishedDelay.running)
            return
        // check that the distance is not too far
        var minX = soldiers.itemAt(focusedSolider).x - shootRange
        var maxX = soldiers.itemAt(focusedSolider).x + shootRange
        var minY = soldiers.itemAt(focusedSolider).y - shootRange
        var maxY = soldiers.itemAt(focusedSolider).y + shootRange
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
                if ((mine_repeater.itemAt(i).state === "active") && check_mine_explode(mine_repeater.itemAt(i),x,y))
                    mine_repeater.itemAt(i).state = "exploded";
            }
        }
    }
    focus: true
    Keys.onPressed: {
        if (event.key === Qt.Key_Space) {
            event.accepted = true;
            soldiers.itemAt(focusedSolider).shooting = true;
       }
    }
    Keys.onReleased: {
        if (event.key === Qt.Key_Space) {
            soldiers.itemAt(focusedSolider).shooting = false;
       }
    }

    Timer {
        id: gameFinishedDelay
        interval: 1000; running: false; repeat: false
        onTriggered: {
            console.debug("gameFinishedDelay timer triggered")
            startButton.visible = true
            startButton.state= "END"
            gameTimer.stop()
            gameScene.state="END"
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
    }

    MoveDestination {
        id:moveDestination
    }

    Timer {
        id:gameTimer
        interval: 70; running: false; repeat: true
        property bool gameWon: false;
        property bool enemiesDead: false;
        property bool soldiersDead: true
        onTriggered: {
            enemiesDead= true
            if ( gameFinishedDelay.running)
                return

            for (var i=0; i<n2.count; i++) {
                if ( n2.itemAt(i).state === "alive")
                    enemiesDead=false
            }
            if (soldiers.itemAt(focusedSolider).x === moveDestination.x &&
                soldiers.itemAt(focusedSolider).y === moveDestination.y) {
                moveDestination.visible= false
            }
            soldiers.itemAt(focusedSolider).moveSoldier()
            for (var j=0; i< mine_repeater.count; i++) {
                if ( mine_repeater.itemAt(j).state === "active") {
                    var minX = mine_repeater.itemAt(j).x - mines.proxmity
                    var maxX = mine_repeater.itemAt(j).x + mines.proxmity
                    var minY = mine_repeater.itemAt(j).y - mines.proxmity
                    var maxY = mine_repeater.itemAt(j).y + mines.proxmity
                    if ( (minX <  soldiers.itemAt(focusedSolider).x) && (soldiers.itemAt(focusedSolider).x < maxX) &&
                         (minY <  soldiers.itemAt(focusedSolider).y) && (soldiers.itemAt(focusedSolider).y < maxY) )
                        {
                        console.debug("stepped on mine")
                        mine_repeater.itemAt(j).state = "exploded"
                        startButton.txt = "Lost"
                        gameFinishedDelay.start()
                        soldiers.itemAt(focusedSolider).state = "dead"
                        }
                }
            }
            for (var j=0; j<n2.count; j++) {
                n2.itemAt(j).moveEvil();
                // are they able to shoot the soldier?
                // check that the distance is not too far
                var range = 40
                var indx = 0
                for (var i=0; i<soldiers.count; i++) {
                    if (soldiers.itemAt(i).state != "dead") {
                        indx=i
                        break
                    }
                }
                var minX = soldiers.itemAt(indx).x - range
                var maxX = soldiers.itemAt(indx).x + range
                var minY = soldiers.itemAt(indx).y - range
                var maxY = soldiers.itemAt(indx).y + range
                if ( (minX < n2.itemAt(j).x) && (n2.itemAt(j).x < maxX)
                        && (minY < n2.itemAt(j).y) && (n2.itemAt(j).y < maxY) ) {
                    if ( soldiers.itemAt(indx).state != "dead" ) {
                        // dead
                        soldiers.itemAt(indx).state = "dead"
                    }

                }
            }
            soldiersDead= true
            for (var i=0; i<soldiers.count; i++) {
                if (soldiers.itemAt(i).state != "dead") {
                    soldiersDead=false
                    break
                }
            }
            if (soldiersDead) {
                console.debug("Lost")
                startButton.txt = "Lost"
                gameTimer.gameWon = false
                gameFinishedDelay.start()
            }

            if (enemiesDead) {
                startButton.txt = "Won"
                gameTimer.gameWon = true
                gameFinishedDelay.start()
                return
            }
            if (gameWon) {
                gameFinishedDelay.start()
                return
            }
        }
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
        id: civilians
        Repeater {
            id:civilian_repeater
            model: 3
            Civilian {

            }
        }
    }
    Row {
        id: n1
        Repeater {
            id:n2
            model: 2
            Enemy {
            }
        }
    }
    property int  focusedSolider: 0
    Row {
        id: s1
        Repeater {
            id:soldiers
            model: 3
            Soldier {
            }
        }
    }

    MouseArea {
        id: gameMouseArea
        signal stateX (string statex)
        onStateX: {
            console.debug('onStateX=', statex)
            if (statex === "PLAYING") {
                gameInitialze();
                gameScene.state = "PLAYING"
            }
            if (statex === "QUIT") {
                Qt.quit()
            }
            if (statex === "SURRENDER") {
                startButton.visible = true
                startButton.txt = "Lost"
                startButton.state= "END"
                gameTimer.stop();
                gameScene.state = "END"
            }
        }

        anchors.fill: land
        onPositionChanged: {
            if ( soldiers.itemAt(focusedSolider).shooting ) {
                shoot(mouseX, mouseY)
            }
        }

        onClicked: {
            if(gameScene.state === "PLAYING") {
                if ( soldiers.itemAt(focusedSolider).shooting ) {
                    shoot(mouseX, mouseY)
                } else {
                    console.debug("gameMouseArea onClicked")

                    // is x,y inside the land?
                    if ( (land.x < mouseX) && (mouseX < land.width)
                            && (land.y < mouseY) && (mouseY < land.height) ) {
                        soldiers.itemAt(focusedSolider).destX = mouseX
                        soldiers.itemAt(focusedSolider).destY = mouseY
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
