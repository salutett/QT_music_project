//播放历史页面

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.0
import QtQml 2.3

ColumnLayout {

    id: history11

    Rectangle {

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text {
            x: 10
            verticalAlignment: Text.AlignBottom
            text: qsTr("播放历史")
            font.family: "宋体"
            font.pointSize: 25
        }
    }

    RowLayout {
        x: 10
        Item {
            width: 10
        }

        height: 80

        MusicTextButton {
            btnText: "刷新记录"
            btnWidth: 120
            btnHeight: 50
            onClicked: {
                getHistory()
            }
        }
        MusicTextButton {
            btnText: "清空记录"
            btnWidth: 120
            btnHeight: 50
            onClicked: {
                clearHistory()
            }
        }
    }

    MusicListView {
        id: historyListView
        onDeleteItem: deleteHistory(index)
    }

    Component.onCompleted: {
        getHistory()
    }
    function getHistory() {
        historyListView.musicList = historySettings.value("history",[])
    }

    function clearHistory() {
        historySettings.setValue("history",[])
        getHistory()
    }

    function deleteHistory(index) {
        var list = historySettings.value("history",[])

        if(list.length<index+1) return
        list.splice(index,1)
        historySettings.value("history",list)

        getHistory()
    }
}
