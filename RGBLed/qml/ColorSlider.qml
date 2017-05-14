import QtQuick 2.5
import QtGraphicalEffects 1.0

Item {
    signal change()
    property bool horizontalMod: false
    property string startColor: "#FFFFFF"
    property string stopColor: "#000000"
    property real value: 0
    property int _len: (horizontalMod)?width-height:height-width
    property int _offset: (horizontalMod)?height/width/2:width/height/2
    id: colorSlider
    Item {
        id: pickerCursor
        width: (horizontalMod)?parent.height:parent.width
        height: width
        z: 2
        Rectangle {
            radius: parent.width/2
            x: (horizontalMod)?_len*value:0
            y: (horizontalMod)?0:_len*value
            width: parent.width;
            height: width
            border.color: "black"
            border.width: 1
            color: "transparent"
            Rectangle {
                radius: width/2
                anchors.fill: parent
                anchors.margins: 1
                border.color: "white"
                border.width: 1
                color: "transparent"
            }
        }
    }
    LinearGradient {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: (horizontalMod)?Qt.point(width, 0):Qt.point(0, height)
        z: 1
        gradient: Gradient {
            GradientStop { position: 0.0; color: colorSlider.startColor }
            GradientStop { position: colorSlider._offset; color: colorSlider.startColor }
            GradientStop { position: 1.0-colorSlider._offset; color: colorSlider.stopColor }
            GradientStop { position: 1.0;  color: colorSlider.stopColor }
        }
    }
    MouseArea {
        anchors.fill: parent
        function handleMouse(mouse) {
            if (mouse.buttons & Qt.LeftButton) {
                var pos = mouse.y
                if(horizontalMod){
                    pos = mouse.x
                }
                pos = pos-pickerCursor.width/2
                pos = Math.max(0, Math.min(colorSlider._len, pos))
                colorSlider.value = 1.0*pos/colorSlider._len
                colorSlider.change();
            }
        }
        onPositionChanged: {
            handleMouse(mouse);
        }
        onPressed: {
            handleMouse(mouse);
        }
    }
}
