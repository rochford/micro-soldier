import QtQuick 1.1

Rectangle {
    id: endMissionScene
    width: 400
    height: 400
    color: "black"

    Timer {
        id:textScrollTimer2
        interval: 50; running: true; repeat: true
        onTriggered: {
            text2.y -= 4
            if (text2.y < -200) {
                textScrollTimer2.stop()
                mainWindow.state="menu"
                menuUiVisibile(true)
            }
        }
    }

    Text {
        id: text2
        y: parent.height
        text: endMissionText
        color: "#ece1e1"
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 22
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            mainWindow.state="menu"
            menuUiVisibile(true)
        }
    }
}
