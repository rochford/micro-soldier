import QtQuick 1.1

Rectangle {
    id: rectangle1
    width: 400
    height: 400
    color: "black"
    property string creditText:
        "MicroSoldier\n\nCopyright 2013\n\nby Tim Rochford\n\n";

    Timer {
        id:textScrollTimer
        interval: 50; running: true; repeat: true
        onTriggered: {
            text.y -= 4
            if (text.y < -200) {
                textScrollTimer.stop()
                mainWindow.state="menu"
            }
        }
    }

    Text {
        id: text
        y: parent.height
        text: creditText
        color: "#ece1e1"
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 22
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            mainWindow.state="menu"
            missionList.visible = true
            menuText.visible = true
            titleText.visible = true
            quitButton.visible = true
            creditButton.visible = true

        }
    }
}
