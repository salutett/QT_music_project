import QtQuick 2.12
import QtQuick.Controls 2.5


Button {

    property alias btnText: self.text

    //检查是否选中
    property alias isCheckable: self.checkable
    property alias isChecked: self.checked

    property alias btnWidth: self.width
    property alias btnHeight: self.height

    id: self

    text: "Button"

    font.family: "宋体"
    font.pointSize: 14

    background: Rectangle {
        implicitHeight: self.height
        implicitWidth: self.width
        color: self.down || (isCheckable && self.checked) ? "#e2f0f8" : "#20e9f4ff"
        radius: 3
    }

    width: 50
    height: 50
    checkable: false
    checked: false
}
