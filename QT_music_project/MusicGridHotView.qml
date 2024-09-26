//热门歌单页面

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Item {

    property  alias list: gridRepeater.model
    Grid {
        id: gridLayout
        anchors.fill: parent
        columns: 4 //一排多少个
        Repeater {
            id: gridRepeater
            Frame {
                padding: 10
                width: parent.width*0.25
                height: parent.width*0.25+20
                background: Rectangle {
                    id: background
                    color: "#ffffffff"
                }
                clip: true

                MusicBorderImage {
                    id: img
                    width: parent.width
                    height: parent.width
                    imgSrc: modelData.coverImgUrl
                }

                Text {
                    anchors {
                        top: img.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    text: modelData.name
                    font.family: "宋体"
                    //判断是否为全屏
                    //window.visibility = Window.Maximized
                    font.pointSize: 8
                    height: 20 //高度
                    width: parent.width
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    elide: Qt.ElideMiddle
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        background.color = "#50000000"
                    }
                    onExited: {
                        background.color = "#ffffffff"//透明
                    }
                    onClicked: {
                        var item = gridRepeater.model[index]
                        console.log("id: "+item.id)

                        page.showPlayList(item.id,"3000")
                    }
                }
            }
        }
    }
}
