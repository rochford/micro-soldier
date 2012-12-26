import QtQuick 1.1

Rectangle {
    width: 400
    height: 400
    color: "black"

    Text {
        id: helpText
        x: 0
        y: 0
        width: 400
        height: 400
        color: "#ffffff"
        text: qsTr("Each soldier is moved individually. Click the mouse to move to the mouse cursor position. Press space to shoot at the mouse position. Select the soldier from the control panel on the right. Soldiers die by stepping on mines or by being shot. The mission ends if a civillian is shot.")
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.pixelSize: 17
    }

    MouseArea {
        id: mousearea1
        anchors.fill: parent
        onClicked: {
            mainWindow.state="menu"
            menuUiVisibile(true)
        }
    }
}
