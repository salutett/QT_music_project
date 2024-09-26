import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12

ToolBar {
    background: Rectangle{
        color: "#00AAAA" //透明背景
    }

    width: parent.width
    Layout.fillWidth: true
    //height: 32
    RowLayout {
        anchors.fill: parent
        //toolbutton主要用于工具栏
        //点上去出现文字提示
        MusicToolButton {
            icon.source: "qrc:/images/music"
            toolTip: "关于"
            onClicked: {
                aboutPop.open()
            }
        }
        MusicToolButton {
            icon.source: "qrc:/images/about"
            toolTip: "gzf"
            onClicked: {
                Qt.openUrlExternally("https://www.baidu.com")
            }
        }
        MusicToolButton {
            id: smallWindow
            iconSource: "qrc:/images/small-window"
            toolTip: "小窗播放"
            onClicked: {
                setWindowSize(330,650)
                normalWindow.visible = true
                smallWindow.visible = false
            }
        }
        MusicToolButton {
            id: normalWindow
            iconSource: "qrc:/images/exit-small-window"
            toolTip: "退出小窗播放"
            visible: false
            onClicked: {
                setWindowSize()
                normalWindow.visible = false
                smallWindow.visible = true
            }
        }
        //创建一个包含文本的区域，使用布局填充宽度
        Item {
            Layout.fillWidth:  true
            height: 32
            Text {
                anchors.centerIn: parent
                text: qsTr("海绵宝宝")
                font.family: "宋体"
                font.pointSize: 15
                color: "#ffffff"
            }
        }
        MusicToolButton {
            icon.source: "qrc:/images/minimize-screen"
            toolTip: "最小化"
            onClicked: {
                window.hide()
            }
        }
        MusicToolButton {
            id: resize
            icon.source: "qrc:/images/small-screen"
            toolTip: "退出全屏"
            visible: false
            onClicked: {
                setWindowSize()
                window.visibility = Window.AutomaticVisibility
                maxWindow.visible = true
                resize.visible = false
            }
        }
        MusicToolButton {
            id: maxWindow
            icon.source: "qrc:/images/full-screen"
            toolTip: "全屏"
            onClicked: {
                window.visibility = Window.Maximized
                maxWindow.visible = false
                resize.visible = true
            }
        }
        MusicToolButton {
            icon.source: "qrc:/images/power"
            toolTip: "退出"
            onClicked: {
                Qt.quit()
            }
        }
    }

    Popup {
        id:aboutPop

        //使用Inset占位
        topInset: 0
        leftInset: 0
        rightInset: 0
        bottomInset: 0

        parent: Overlay.overlay //居中
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        width: 250
        height: 230

        background: Rectangle {
            color: "#e9f4ff"
            radius: 5
            border.color: "#2273a7ab"
        }

        contentItem: ColumnLayout {

            width: parent.width
            height: parent.height
            Layout.alignment: Qt.AlignHCenter

            Image {
                Layout.preferredHeight: 60
                Layout.fillWidth: true
                source: "qrc:/images/music"
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: qsTr("续加仪")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize:  16
                color: "#8573a7ab"
                font.family: "宋体"
                font.bold: true
            }

            Text {
                text: qsTr("这是我的Cloud Music Plyer")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize:  16
                color: "#8573a7ab"
                font.family: "宋体"
                font.bold: true
            }

            Text {
                text: qsTr("www.baidu.com")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize:  16
                color: "#8573a7ab"
                font.family: "宋体"
                font.bold: true
            }
        }
    }

    function setWindowSize (width = window.mWINDOW_WIDTH,height = window.mWINDOW_HEIGHT) {
        window.height = height
        window.width = width
        window.x = (Screen.desktopAvailableWidth - window.width) / 2
        window.y = (Screen.desktopAvailableHeight - window.height) / 2
    }
}

