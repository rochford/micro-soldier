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
import "GameState.js" as GameState

Rectangle {
    property int mineCount : mainWindow.mineCount
    property int enemyCount : mainWindow.enemyCount
    property int soldierCount : mainWindow.soldierCount
    focus: true

    id:gameScene
    width: 400
    height: 400
    state: "START"

    Image {
        id: land
        width: 340
        height: parent.height
        source: 'images/land.png'
    }
    ControlPanel {
        id: controlPanel
        Button {
            id: endButton
            txt: "Surrender"
            anchors {
                bottom: parent.bottom
                left: parent.left
            }
        }
    }

    states: [
        State {
            name: "START"
            PropertyChanges { target: startButton; visible: true}
            PropertyChanges { target: gameScene; color:"red"}
        },
        State {
            name: "PLAYING"
            PropertyChanges { target: startButton; visible: false}
            PropertyChanges { target: gameScene; color:"green"}
            PropertyChanges { target: gameScene; color:"lime"}
        },
        State {
            name: "END"
            PropertyChanges { target: startButton; visible: true}
            PropertyChanges { target: gameScene; color:"blue"}
        }
    ]
    property string gameOverTextLiteral:'Mission Failed'
    property string gameOverTextWonLiteral:'Mission Accomplished'
    property int shootRange: 140

    function pressed() {
        mycursor.cursor("target")
        event.accepted = true;
        soldiers.itemAt(focusedSolider).shooting = true;

    }
    function released()
    {
        mycursor.cursor("normal")
        soldiers.itemAt(focusedSolider).shooting = false;
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Space) {
            mycursor.cursor("target")
            event.accepted = true;
            soldiers.itemAt(focusedSolider).shooting = true;
       }
    }
    Keys.onReleased: {
        if (event.key === Qt.Key_Space) {
            mycursor.cursor("normal")
            soldiers.itemAt(focusedSolider).shooting = false;
       }
    }


    Timer {
        id: gameFinishedDelay
        interval: 1000; running: false; repeat: false
        onTriggered: {
            startButton.visible = true
            startButton.state= "END"
            gameTimer.stop()
            gameScene.state="END"
        }
    }

    Timer {
        id:bulletTimer
        interval: 250; running: false; repeat: false
        onTriggered: {
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
        interval: 80; running: false; repeat: true
        property bool gameWon: false;
        property bool enemiesDead: false;
        property bool soldiersDead: true
        onTriggered: {
            enemiesDead= true
            if ( gameFinishedDelay.running)
                return

            for (var i=0; i<n2.count; i++) {
                for (var j=0; j< mine_repeater.count; j++) {
                    if ( mine_repeater.itemAt(j).state === "active") {
                        var minX = mine_repeater.itemAt(j).x - mines.proxmity
                        var maxX = mine_repeater.itemAt(j).x + mines.proxmity
                        var minY = mine_repeater.itemAt(j).y - mines.proxmity
                        var maxY = mine_repeater.itemAt(j).y + mines.proxmity
                        if ( (minX <  soldiers.itemAt(focusedSolider).x) && (soldiers.itemAt(focusedSolider).x < maxX) &&
                             (minY <  soldiers.itemAt(focusedSolider).y) && (soldiers.itemAt(focusedSolider).y < maxY) )
                            {
                            console.debug("enemy on mine")
                            mine_repeater.itemAt(j).state = "exploded"
                            n2.itemAt(i).state = "dead"
                            }
                    }
                }

                if ( n2.itemAt(i).state === "alive")
                    enemiesDead=false
            }
            if (soldiers.itemAt(focusedSolider).x === moveDestination.x &&
                soldiers.itemAt(focusedSolider).y === moveDestination.y) {
                moveDestination.visible= false
            }
            soldiers.itemAt(focusedSolider).moveSoldier()
            for (var j=0; j< mine_repeater.count; j++) {
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
                        mine_repeater.itemAt(j).exploded( mine_repeater.itemAt(j).x,  mine_repeater.itemAt(j).y)
                        soldiers.itemAt(focusedSolider).state = "dead"
                        }
                }
            }
            for (var j=0; j<civilian_repeater.count; j++) {
                if (civilian_repeater.itemAt(j).state === "dead") {
                    console.debug("Lost")
                    startButton.txt = "Lost"
                    gameTimer.gameWon = false
                    gameFinishedDelay.start()
                    GameState.updateSoldierModel(false)
                    return
                }
            }

            for (var j=0; j<n2.count; j++) {
                n2.itemAt(j).moveEvil();
                var indx = -1
                // are they able to shoot the soldier?
                // check that the distance is not too far
                var distX = 1000;
                var distY = 1000;
                for (var i=0; i<soldiers.count; i++) {
                    if (soldiers.itemAt(i).state != "dead") {
                        // if the distance is less, then select thecloser soldier
                        var deltaX = Math.abs(soldiers.itemAt(i).x - n2.itemAt(j).x);
                        var deltaY = Math.abs(soldiers.itemAt(i).y - n2.itemAt(j).y);
                        if ( ( distX > deltaX ) && ( distY > deltaY ) ) {
                            indx=i
                            distX = deltaX;
                            distY = deltaY;
                        }
                    }
                }

                if (indx != -1) {
                    var range = 40
                    var minX = soldiers.itemAt(indx).x - range
                    var maxX = soldiers.itemAt(indx).x + range
                    var minY = soldiers.itemAt(indx).y - range
                    var maxY = soldiers.itemAt(indx).y + range
                    if ( (minX < n2.itemAt(j).x) && (n2.itemAt(j).x < maxX)
                            && (minY < n2.itemAt(j).y) && (n2.itemAt(j).y < maxY) ) {
                        if ( soldiers.itemAt(indx).state != "dead" ) {
                            // dead
                            soldiers.itemAt(indx).state = "dead"
                            missionSoldierModel.get(indx).alive = false
                        }

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
                GameState.updateSoldierModel(false)
            }

            if (enemiesDead) {
                startButton.txt = "Won"
                gameTimer.gameWon = true
                gameFinishedDelay.start()
                GameState.updateSoldierModel(true)
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
            model: mineCount
            Mine {
            }
        }
    }
    Row {
        id: civilians
        Repeater {
            id:civilian_repeater
            model: 10
            Civilian {

            }
        }
    }
    Row {
        id: n1
        Repeater {
            id:n2
            model: enemyCount
            Enemy {
            }
        }
    }
    property int  focusedSolider: 0
    Row {
        id: s1
        Repeater {
            id:soldiers
            model: soldierCount
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
                GameState.gameInitialize()
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
                GameState.shoot(mouseX, mouseY)
            }
        }

        onClicked: {
            if (gameMouseArea.pressedButtons & Qt.RightButton)
                console.debug("Right Button")
            if(gameScene.state === "PLAYING") {
                if ( soldiers.itemAt(focusedSolider).shooting ) {
                    GameState.shoot(mouseX, mouseY)
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
