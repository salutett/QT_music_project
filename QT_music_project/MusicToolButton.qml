
import QtQuick 2.12
import QtQuick.Controls 2.5


ToolButton {

    property string iconSource: ""

    property string toolTip: ""
    //检查是否选中
    property bool isCheckable: false
    property bool isChecked: false

    id: self

    icon.source: iconSource

    ToolTip.visible: hovered
    ToolTip.text: toolTip

    background: Rectangle {
        color: self.down || (isCheckable && self.checked) ? "#eeeeee" : "#00000000"
    }

    icon.color: self.down || (isCheckable && self.checked) ? "#00000000" : "e2f0f8"

    checkable: isCheckable
    checked: isChecked

}
