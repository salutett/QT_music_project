//热门歌单页面

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Item {

    property  alias list: gridRepeater.model
    Grid {
        id: gridLayout
        anchors.fill: parent
        columns: 3 //一排多少个
        Repeater {
            id: gridRepeater
            Frame {
                id:last1
                padding: 5
                width: parent.width*0.33
                height: parent.width*0.1
                background: Rectangle {
                    id: background
                    color: "#ffffffff"
                }
                clip: true

                MusicBorderImage {
                    id: img
                    width: parent.width*0.25
                    height: parent.width*0.25
                    imgSrc: modelData.album.picUrl
                }

                Text {
                    id: name
                    anchors {
                        left: img.right
                        verticalCenter: parent.verticalCenter
                        bottomMargin: 10
                        leftMargin: 5
                    }
                    text: modelData.album.name
                    font.family: "宋体"
                    //判断是否为全屏
                    //window.visibility = Window.Maximized
                    font.pointSize: 11
                    height: 30 //高度
                    width: parent.width*0.72
                    elide: Qt.ElideRight
//歌手
//                    Text {
//                        anchors {
//                            //left:img.right
//                            left: parent.right
//                            top: name.bottom
//                            leftMargin: 5
//                        }
//                        text: modelData.artists[0].name
//                        font.family: "宋体"
//                        height: 30 //高度
//                        width: parent.width*0.72
//                        elide: Qt.ElideRight
//                    }
                }
//                MouseArea {
//                    anchors.fill: parent
//                    hoverEnabled: true
//                    cursorShape: Qt.PointingHandCursor
//                    onEntered: {
//                        background.color = "#50000000"
//                    }
//                    onExited: {
//                        background.color = "#ffffffff"//透明
//                    }
//                }
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
                        //console.log("index"+index)
                        //if(latest1.currentIndex===index){
                        console.log("latest1:"+gridRepeater.model[index])
                        var item = gridRepeater.model[index]
                        var targetId = item.id + "" //转为字符串
                        console.log("id+:"+targetId)
                        //播放歌曲
                        layoutBottomView.current = -1
                        layoutBottomView.playList = [{id: targetId,name:"",artist: "",cover: "",album: ""}]
                        layoutBottomView.current = 0
                        //}
                    }
                }
            }
        }
    }
}
