import QtQuick 2.5
import QtGraphicalEffects 1.0

Rectangle{
    signal change()
    signal changeStat()
    property string value: hsvToRgb(radialSliderHue.value, sliderS.value*100, 100-(sliderV.value*100))
    property bool stateBtn: false

    id: colorPicker

    anchors.margins: 20


    function hsvToRgb(H, S, V) {
        var RGB = '';
        var Hi, Vmin, Vinc, Vdec, a
        Hi = Math.floor(H/60)
        Vmin = (100-S)*V/100;
        a = (V-Vmin)*(H%60)/60
        Vinc = Vmin+a
        Vdec = V-a

        switch (Hi) {
        case 0:
            RGB = Qt.rgba(V/100,Vinc/100,Vmin/100,1)
            break;
        case 1:
            RGB = Qt.rgba(Vdec/100,V/100,Vmin/100,1)
            break;
        case 2:
            RGB = Qt.rgba(Vmin/100,V/100,Vinc/100,1)
            break;
        case 3:
            RGB = Qt.rgba(Vmin/100,Vdec/100,V/100,1)
            break;
        case 4:
            RGB = Qt.rgba(Vinc/100,Vmin/100,V/100,1)
            break;
        case 5:
            RGB = Qt.rgba(V/100,Vmin/100,Vdec/100,1)
            break;
        }

        return RGB;
    }

    function setColor(color) {
        var r = parseInt(color.toString().substr(1, 2), 16);
        var g = parseInt(color.toString().substr(3, 2), 16);
        var b = parseInt(color.toString().substr(5, 2), 16);

        r = r / 255
        g = g / 255
        b = b / 255

        var max = Math.max(r, g, b)
        var min = Math.min(r, g, b);
        var h
        var v = max
        var d = max - min;
        var s = max == 0 ? 0 : d / max;

        if (max == min) {
            h = 0; // achromatic
        } else {
            switch (max) {
            case r:
                h = (g - b) / d + (g < b ? 360 : 0);
                break;
            case g:
                h = (b - r) / d + 120;
                break;
            case b:
                h = (r - g) / d + 240;
                break;
            }
            h *= 60;
        }
        sliderS.value = s
        sliderV.value = v
        radialSliderHue.value = h
    }

    ColorSlider{
        id: sliderS
        width: parent.width*0.1
        height: radialSliderHue.height
        anchors.margins: 5*dp
        anchors.left: parent.left
        startColor: "#FFFFFF"
        value: 1
        stopColor: colorPicker.hsvToRgb(radialSliderHue.value, 100, 100)
        onChange: colorPicker.change()
    }

    Rectangle{
        property int value: 0

        id: radialSliderHue
        radius: width/2
        width: parent.width*0.8
        height: width
        anchors.left: sliderS.right
        anchors.top: parent.top
        z: 1
        ConicalGradient{
            width: radialSliderHue.width
            height: radialSliderHue.height
            angle: 0.0
            source: radialSliderHue
            gradient: Gradient {
                GradientStop {
                    position: 0.000
                    color: Qt.rgba(1, 0, 0, 1)
                }
                GradientStop {
                    position: 0.167
                    color: Qt.rgba(1, 1, 0, 1)
                }
                GradientStop {
                    position: 0.333
                    color: Qt.rgba(0, 1, 0, 1)
                }
                GradientStop {
                    position: 0.500
                    color: Qt.rgba(0, 1, 1, 1)
                }
                GradientStop {
                    position: 0.667
                    color: Qt.rgba(0, 0, 1, 1)
                }
                GradientStop {
                    position: 0.833
                    color: Qt.rgba(1, 0, 1, 1)
                }
                GradientStop {
                    position: 1.000
                    color: Qt.rgba(1, 0, 0, 1)
                }
            }
        }
        Rectangle {
            id: hueMarker
            width: parent.width*0.2;
            height: width
            radius: width/2
            x: (parent.width/2 - width / 2) + (parent.width/2-width / 2) * Math.cos(radialSliderHue.value * 1 * (3.14 / 180) - (90 * (3.14 / 180)))
            y: (parent.height/2 - height / 2) + (parent.width/2-width / 2) * Math.sin(radialSliderHue.value * 1 * (3.14 / 180) - (90 * (3.14 / 180)))
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
        Rectangle{
            id: btnPower
            width: parent.width*0.6
            height: parent.height*0.6
            radius: width/2
            color: '#444'
            state: colorPicker.stateBtn?"on":"off"
            border.color: window.color
            border.width: 7*dp
            anchors.centerIn: parent

            Rectangle{
                width: parent.width*0.45
                height: width
                anchors.centerIn: parent
                radius: width/2
                z: 1
                border.color: '#ffffff'
                border.width: 3*dp
                color: parent.color
            }

            Rectangle{
                width: 15*dp
                height: btnPower.height*0.3
                x: (parent.width*0.5) - (width/2)
                y: parent.height*0.15
                z: 2
                border.color: parent.color
                border.width: 6*dp
                color: '#ffffff'
            }
            states: [
                State {
                    name: "on"
                    PropertyChanges { target: colorPicker; stateBtn: true }
                    PropertyChanges { target: btnPower; color: 'green' }
                },
                State {
                    name: "off"
                    PropertyChanges { target: colorPicker; stateBtn: false }
                    PropertyChanges { target: btnPower; color: '#444' }
                }
            ]
        }
        MouseArea {
            property int currentHandler: -1
            property int previousAlpha: 0
            function chooseHandler(mouseX, mouseY) {
                // return: 0 - btn; 1 - hueSlider; -1 - etc
                if (btnPower.width / 2 > Math.sqrt(Math.pow(radialSliderHue.width/2 - mouseX, 2) + Math.pow(radialSliderHue.width/2 - mouseY, 2)))
                    return 0
                else if (radialSliderHue.width/2 > Math.sqrt(Math.pow(radialSliderHue.width/2 - mouseX, 2) + Math.pow(radialSliderHue.width/2 - mouseY, 2)))
                    return 1
                return -1
            }
            function findAlpha(x, y) {
                var alpha = (Math.atan((y - radialSliderHue.width/2)/(x - radialSliderHue.width/2)) * 180) / 3.14 + 90
                if (x < radialSliderHue.width/2)
                    alpha += 180

                return alpha
            }
            anchors.fill: parent
            onPressed: {
                currentHandler = chooseHandler(mouseX, mouseY)
                if (currentHandler == 1){
                    radialSliderHue.value = findAlpha(mouseX, mouseY);
                    colorPicker.change()
                }
            }
            onReleased: {
                var nHandler = chooseHandler(mouseX, mouseY)
                if(nHandler == 0 && currentHandler == 0){
                    btnPower.state = !colorPicker.stateBtn?"on":"off"
                    colorPicker.changeStat();
                    //window.setLedStat(btnPower.on);
                }
                currentHandler = -1
            }
            onPositionChanged: {
                if (currentHandler == 1){
                    radialSliderHue.value = findAlpha(mouseX, mouseY);
                    colorPicker.change()
                }
            }
        }
    }

    Rectangle{
        id: colorIndicator
        width: sliderS.width
        height: sliderV.height
        anchors.margins: 5*dp
        anchors.top: sliderS.bottom
        anchors.left: parent.left
        color: colorPicker.value
    }

    ColorSlider{
        id: sliderV
        width: radialSliderHue.width
        height: sliderS.width
        anchors.margins: 5*dp
        anchors.left: colorIndicator.right
        anchors.top: radialSliderHue.bottom
        horizontalMod: true
        startColor: colorPicker.hsvToRgb(radialSliderHue.value, 100, 100)
        stopColor: "#000000"
        onChange: colorPicker.change()
    }

    // TODO выставить z и определить место
    Rectangle{
        color: parent.color
        height: parent.width*0.1
        width: height
        anchors.top: parent.top
        anchors.right: parent.right
        z: 2
        Image {
            source: "qrc:/images/AddFavorites"
            anchors.fill: parent
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                backend.addFavorite(colorPicker.value)
                showMessage("Цвет сохранен")
            }
        }
    }
}
