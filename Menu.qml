import QtQuick 1.1

Rectangle {
    id: mainWindow
    width: 400
    height: 400
    color: "#181616"
    border.color: "#000000"
    focus: true
    Loader {
        id: loader
        anchors.fill: parent
        visible: source != ""
        focus: true
    }

    states: [
        State {
            name: "menu"
            PropertyChanges {
                target: loader
                source: "Menu.qml"
            }
        },
        State {
            name: "play"
            PropertyChanges {
                target: loader
                source: "soldier_qml.qml"
            }
/*            PropertyChanges {
                target: loader
                focus: false
            }
            */
        },
        State {
            name: "credits"
            PropertyChanges {
                target: loader
                source: "Credits.qml"
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
            missionName: "Intro to Hell"
            newState: "play"
        }
        MenuMissionItem {
            missionName: "Lords of War"
            newState: "play"
        }
        MenuMissionItem {
            missionName: "Final Finale"
            newState: "play"
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
                quitButton.visible = false
                creditButton.visible = false
                missionList.visible = false
                menuText.visible = false
                titleText.visible = false
            }
        }
    }
}
