//背景制作

import QtQuick 2.12
import QtGraphicalEffects 1.0

Rectangle {
    property alias backgroundImageSrc: backgroundImage.source

    Image {
        id: backgroundImage
        source: "qrc:/images/player"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }
    ColorOverlay {
        id: backgroundImageOverlay
        anchors.fill: backgroundImage
        source: backgroundImage
        color: "#55000000"
    }

    FastBlur {
        anchors.fill: backgroundImageOverlay
        source: backgroundImageOverlay
        radius: 80 //模糊效果
    }
}
