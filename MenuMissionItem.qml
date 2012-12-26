import QtQuick 1.1

Rectangle {
    id: rectangle1
    property string colour: "#aa6666"
    property string missionName: "Mission"
    property string newState: ""
    property int mineCount: 0
    property int enemyCount: 0
    property int soldierCount: 0

    width: 100
    height: 100
    color: "#382828"
    MouseArea {
        anchors.fill: parent
        onClicked: {
            mainWindow.state = newState
            mainWindow.mineCount = mineCount
            mainWindow.enemyCount = enemyCount
            mainWindow.soldierCount = soldierCount
            menuUiVisibile(false)
            console.debug(activeFocus)
        }
    }
    Image {
        id: image1
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.height: 50
        sourceSize.width: 50
        source: "images/land.png"

    }

    Text {
        color: "#f5eaea"
        text: missionName
        wrapMode: Text.WordWrap
        font.bold: true
        font.pointSize: 9
        styleColor: "#f3ecec"
        horizontalAlignment: Text.AlignHCenter
        anchors.top: image1.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
