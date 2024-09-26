//的词滚动页面

import QtQuick 2.0
import QtQuick.Layouts 1.3

Rectangle {
    property alias lyrics: list.model
    property alias current: list.currentIndex

    id: lyricView

    Layout.preferredHeight: parent.height*0.8
    Layout.alignment: Qt.AlignHCenter

    clip: true

    ListView {
        id: list
        anchors.fill: parent
        model:["暂无歌词","海绵宝宝","海绵宝宝"]
        delegate: listDelegate
        highlight: Rectangle {
            color: "#2073a7ab"
        }
        highlightMoveDuration: 0
        highlightResizeDuration: 0
        currentIndex: 0
        preferredHighlightBegin: parent.height/2 - 50
        preferredHighlightEnd: parent.height/2
        highlightRangeMode: ListView.StrictlyEnforceRange //居中当前行
    }

    Component {
        id: listDelegate
        Item {
            id: delegateItem
            width: parent.width
            height: 50
            Text {
                text: modelData
                anchors.centerIn: parent
                color: index==list.currentIndex?"black":"#505050" //灰色
                font {
                    family: "宋体"
                    pointSize: 10
                }
            }
            //高亮
            states: State {
                when: delegateItem.ListView.isCurrentItem
                PropertyChanges {
                    target:  delegateItem
                    scale: 1.2 //放大属性
                }
            }
            MouseArea {
                anchors.fill: parent
            }
        }
    }
}
