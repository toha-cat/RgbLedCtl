import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    id: window
    visible: true
    width: 315
    height: 500
    color: "#3C3C3C"

    property var currentView: "color"
    property var currentLedColor: "#FFFFFF"
    property var currentLedStat: false

    function messConnected()
    {
        showMessage("Подключился")
    }
    function messDiconnected()
    {
        showMessage("Подключение потеряно")
    }

    function showMessage(mess)
    {
        alertMesage.text = mess;
        alertMesageBox.state = "visibled";
        messTimer.start()
    }

    function hideMessage()
    {
        messTimer.stop()
        alertMesageBox.state = "hidden";
    }

    function setLedColor(color)
    {
        currentLedColor = color
        if(currentLedStat){
            backend.changeColor(currentLedColor);
        }
    }

    function colorUpdate(color)
    {
        colorPicker.setColor(color);
    }

    Rectangle{
        id: contentBox
        anchors.fill: parent
        anchors.margins: 10*dp
        color: window.color

        property bool isPortrait: (height>width)

        GridView {
            id: favoritList

            anchors.margins: 10*dp
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.isPortrait?parent.right:colorPicker.left
            //width: parent.isPortrait?parent.width:parent.width-parent.height
            height: parent.isPortrait?width/2:parent.height
            cellHeight: parent.isPortrait?width/4:width/3
            cellWidth: cellHeight
            model: favoritesModel
            clip: true

            highlight: Rectangle {
                color: "#00000000"
                z:2
                Image {
                    source: "qrc:/images/Checked"
                    anchors.fill: parent
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    anchors.margins: 15*dp
                }
            }

            delegate: Item {
                property var view: GridView.view
                property var isCurrent: GridView.isCurrentItem

                height: view.cellHeight
                width: view.cellWidth

                Rectangle {
                    anchors.margins: 10*dp
                    anchors.fill: parent
                    color: modelData
                    radius: width/2
                    border {
                        color: "#ffffff"
                        width: 1
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            view.currentIndex = model.index
                            setLedColor(modelData)
                        }
                    }
                }
            }
        }

        ColorPicker{
            id: colorPicker
            anchors.top: parent.isPortrait?favoritList.bottom:parent.top
            //anchors.left: parent.isPortrait?parent.left:favoritList.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: parent.isPortrait?parent.width-parent.anchors.margins*2:parent.height
            color: window.color
            z: 1
            onChange: {
                setLedColor(colorPicker.value);
            }
            onChangeStat: {
                currentLedStat = colorPicker.stateBtn;
                if(currentLedStat){
                    backend.changeColor(currentLedColor);
                }
                else{
                    backend.changeColor("#000000");
                }
            }
        }
    }

    Rectangle{
        id: alertMesageBox
        anchors.left: parent.left
        anchors.right: parent.right

        height: 50*dp
        color: "#002aff"
        state:"hidden"
        z: 2
        y: parent.height+height

        Timer {
            id: messTimer
            interval: 2000
            running: false
            repeat: false
            onTriggered: hideMessage()
        }

        states: [
            State {
                name: "hidden"
                PropertyChanges { target: alertMesageBox; y: parent.height+height}
            },

            State {
                name: "visibled"
                PropertyChanges { target: alertMesageBox; y: parent.height-height}
            }
        ]

        transitions: Transition {
            NumberAnimation { properties: "y"; duration: 500; easing.type: Easing.OutQuad }
        }

        Text {
            id: alertMesage
            anchors.fill: parent
            anchors.margins: 7*dp
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 11*dp
            wrapMode: Text.WordWrap
            renderType: Text.NativeRendering
            //text: qsTr("test")
            color: "#FFFFFF"
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                hideMessage();
            }
        }
    }
}

