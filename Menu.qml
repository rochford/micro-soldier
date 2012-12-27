/*
    This file is part of Micro Soldier.

    Micro Soldier is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Micro Soldier is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Micro Soldier.  If not, see <http://www.gnu.org/licenses/>.
  */
import QtQuick 1.1
import "GameState.js" as GameState

Rectangle {
    id: mainWindow
    property bool applicationInitialized: false
    width: 400
    height: 400
    color: "#181616"
    border.color: "#000000"
    focus: true
    property int mineCount: 0
    property int enemyCount: 0
    property int soldierCount: 0
    property string endMissionText:
        "MicroSoldier\n\nCopyright 2013\n\nby Tim Rochford\n\n";
    property variant names: [ 'Adam', 'Bob', 'Charlie', 'David', 'Eddy', 'Frank', 'George', 'Harry',
        'Ian', 'Jerry', 'Ken', 'Lee', 'Mike', 'Nick', 'Owen', 'Peter', 'Qi', 'Rob', 'Steve', 'Tom', 'Uwe', 'Vic', 'Wally', 'Xi', 'Yeon', 'Zack' ]
    ListModel {
        id: soldierModel
    }
    ListModel {
        id: missionSoldierModel
    }


    Loader {
        id: loader
        anchors.fill: parent
        visible: source != ""
        focus: true

    }


    onStateChanged: {
        console.debug("XXX",state)
        if (state==="play" ) {
            if ( ! mainWindow.applicationInitialized) {
                // setup the soldierModel
                GameState.initializeSoldierModel()
            }
        }
    }

    states: [
        State {
            name: "menu"
            PropertyChanges {
                target: loader
                source: "Menu.qml"
            }

            PropertyChanges {
                target: soldiersLeftText
                text: "Soldiers Left:" + GameState.soldierModelAlive()
            }

        },
        State {
            name: "play"
            PropertyChanges {
                target: loader
                source: "soldier_qml.qml"
            }
        },
        State {
            name: "credits"
            PropertyChanges {
                target: loader
                source: "Credits.qml"
            }
        },
        State {
            name: "endMission"
            PropertyChanges {
                target: loader
                source: "EndMission.qml"
            }
        },
        State {
            name: "help"
            PropertyChanges {
                target: loader
                source: "Help.qml"
            }
        }
    ]
    Keys.onPressed: {
        console.debug("menu pressed")
    }

    Text {
        id: menuText
        x: 140
        y: 166
        color: "#ece1e1"
        text: qsTr("Select Your Mission")
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        wrapMode: Text.WordWrap
        font.pixelSize: 26
    }
    Row {
        id: missionList
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: menuText.bottom
        MenuMissionItem {
            missionName: "Into Hell"
            newState: "play"
            mineCount: 3
            enemyCount: 1
            soldierCount: 1
        }
        MenuMissionItem {
            missionName: "Lords of War"
            newState: "play"
            mineCount: 5
            enemyCount: 10
            soldierCount: 2
        }
        MenuMissionItem {
            missionName: "Final Finale"
            newState: "play"
            mineCount: 30
            enemyCount: 1
            soldierCount: 3
        }
    }

    onActiveFocusChanged: {
        console.debug("menu active focus change =",activeFocus)
    }

    Text {
        id: titleText
        x: 149
        y: 86
        color: "#fdf4f4"
        text: qsTr("microSolider")
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        styleColor: "#f9f4f4"
        horizontalAlignment: Text.AlignHCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 300
        font.pixelSize: 39
    }

    Button {
        id: quitButton
        anchors.left: parent.left
        anchors.leftMargin: 340
        anchors.top: parent.top
        anchors.topMargin: 329
        txt: "Quit"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("quit clicked")
                Qt.quit()
            }
        }
    }

    Button {
        id: creditButton
        x: 272
        y: 329
        anchors.right: quitButton.left
        anchors.rightMargin: 10
        txt: "Credits"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("credits clicked")
                mainWindow.state = "credits"
                menuUiVisibile(false)
            }
        }
    }
    Button {
        id: helpButton
        x: 197
        y: 329
        anchors.right: creditButton.left
        anchors.rightMargin: 13
        txt: "Help"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("help clicked")
                mainWindow.state = "help"
                menuUiVisibile(false)
            }
        }
    }
    Button {
        id: resetButton
        x: 125
        y: 329
        anchors.right: helpButton.left
        anchors.rightMargin: 12
        txt: "Reset"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("reset clicked")
                soldierModel.clear()
                applicationInitialized = false
                GameState.initializeSoldierModel()
                soldiersLeftText.text = "Soldiers Left:" + GameState.soldierModelAlive()
            }
        }
    }
    Text {
        id: soldiersLeftText
        y: 348
        color: "#f9f4f4"
        text: "" // "Soldiers Left:" + GameState.soldierModelAlive()
        anchors.right: resetButton.left
        anchors.rightMargin: 13
        font.pixelSize: 12
        onTextChanged: {
            console.debug("soldiersLeftText changed text=", text)
        }
    }

    function menuUiVisibile(visible) {
        console.debug("menuUIVisble ", visible)
        quitButton.visible = visible
        creditButton.visible = visible
        helpButton.visible = visible
        missionList.visible = visible
        menuText.visible = visible
        titleText.visible = visible
        soldiersLeftText.visible = visible
        resetButton.visible = visible
    }
}
