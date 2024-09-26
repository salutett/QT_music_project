import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Rectangle {
    property string imgSrc: "qrc:/images/player"
    property int borderRadius: 5
    property bool isRotating: false
    property real rotationAngel: 0.0

    radius: borderRadius

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "#101010"
        }
        GradientStop {
            position: 0.5
            color: "#a0a0a0"
        }
        GradientStop {
            position: 1.0
            color: "#505050"
        }
    }

//    MusicRoundImage {
//        id: image
//        imgSrc: imgSrc
//        width: parent.width*0.9
//        height: parent.height*0.9
//        borderRadius: borderRadius
//    }

    Image {
        id: image
        anchors.centerIn: parent
        source: imgSrc
        smooth: true
        visible: false
        width: parent.width*0.9
        height: parent.height*0.9
        fillMode: Image.PreserveAspectCrop
        antialiasing: true
    }

    Rectangle {
        id: mask
        color: "black"
        anchors.fill: parent
        radius: borderRadius
        visible: false
        smooth: true
        border.width: 20
        border.color: "#ffffff" //白色
        antialiasing: true //抗锯齿
    }

    OpacityMask {
        id: maskImage
        anchors.fill: image
        source: image
        maskSource: mask
        visible: true
        antialiasing: true //抗锯齿
    }

    NumberAnimation {
        running: isRotating
        loops: Animation.Infinite
        target: maskImage
        from: rotationAngel
        to: 360+rotationAngel
        property: "rotation"
        duration: 100000 //100s
        onStopped: {
            rotationAngel = mask.rotation
        }
    }
}
