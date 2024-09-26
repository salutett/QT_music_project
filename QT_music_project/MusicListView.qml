//搜索框实现

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQml 2.12
import QtQuick.Shapes 1.12

//放在顶部
Frame {

    property var musicList: []
    property int all: 0
    property int pageSize: 60
    property int current: 0
    property bool deletable: true
    property bool favotitable: true

    signal loadMore(int offset,int current)
    signal deleteItem(int index)

    onMusicListChanged: {
        musicList.length
        listViewModel.clear() //先清空数据
        listViewModel.append(musicList)
    }

    Layout.fillHeight: true
    Layout.fillWidth: true
    clip: true
    padding: 0
    background: Rectangle{
        color: "#00000000"
    }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.bottomMargin: 70 //两者的间距
        model: ListModel {
            id: listViewModel
        }
        delegate: listViewDelegate
        ScrollBar.vertical: ScrollBar{
            anchors.right: parent.right
        }
        header: listViewHeader
//        highlight: Rectangle {
//            color: "#f0f0f0" //高亮
//        }
        highlightMoveDuration: 0
        highlightResizeDuration: 0 //移动延迟为0
    }

    Component {
        id: listViewDelegate
        Rectangle {
            //color: "#aaa" //灰色
            id:listViewDelegateItem
            height: 45
            width: listView.width

            Shape {
                anchors.fill: parent
                ShapePath {
                    strokeWidth: 0
                    strokeColor: "#50000000" //灰色
                    strokeStyle: ShapePath.SolidLine
                    startX: 0
                    startY: 45
                    PathLine {
                        x: 0
                        y: 45
                    }
                    PathLine {
                        x: parent.width
                        y:45
                    }
                }
            }

            MouseArea {
                RowLayout {
                    width: parent.width
                    height: parent.height
                    spacing: 15
                    x:5 //缩进，保证第一个元素不贴在里面
                    Text {
                        text: index+1+pageSize*current
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width*0.05
                        font.family: "宋体"
                        font.pointSize: 13
                        color: "black"
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: name
                        Layout.preferredWidth: parent.width*0.4
                        font.family: "宋体"
                        font.pointSize: 13
                        color: "black"
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: artist
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width*0.15
                        font.family: "宋体"
                        font.pointSize: 13
                        color: "black"
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: album
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width*0.15
                        font.family: "宋体"
                        font.pointSize: 13
                        color: "black"
                        elide: Qt.ElideRight
                    }
    //                Text {
    //                    text: "操作"
    //                    horizontalAlignment: Qt.AlignHCenter
    //                    Layout.preferredWidth: parent.width*0.15
    //                    font.family: "宋体"
    //                    font.pointSize: 13
    //                    color: "black"
    //                    elide: Qt.ElideRight
    //                }

                    Item {
                        Layout.preferredWidth: parent.width*0.15
                        RowLayout {
                            anchors.centerIn: parent
                            MusicIconButton {
                                iconSource: "qrc:/images/pause"
                                iconHeight: 32
                                iconWidth: 32
                                toolTip: "播放"
                                onClicked: {
                                    //播放
                                    console.log("d11")
                                    layoutBottomView.current = -1
                                    layoutBottomView.playList = musicList
                                    console.log("music::  "+musicList)
                                    layoutBottomView.current = index
                                    console.log("f11")

                                    //layoutBottomView.playMusic(index)                                }
                                }
                            }
                            MusicIconButton {
                                visible: favotitable
                                iconSource: "qrc:/images/favorite"
                                iconHeight: 32
                                iconWidth: 32
                                toolTip: "喜欢"
                                onClicked: {
                                    //喜欢
                                    console.log("music: "+musicList[index].album)
                                    layoutBottomView.saveFavorite({
                                                                      id: musicList[index].id+"",
                                                                      name: musicList[index].name,
                                                                      artist: musicList[index].artist,
                                                                      url: musicList[index].url?musicList[index].url: "",
                                                                      type: musicList[index].type?musicList[index].type: "0",
                                                                      album: musicList[index].album?musicList[index].album: "本地音乐"
                                                                  })
                                    //favorite111.getFavorite()
                                }
                            }
                            MusicIconButton {
                                visible: deletable
                                iconSource: "qrc:/images/clear"
                                iconHeight: 32
                                iconWidth: 32
                                toolTip: "删除"
                                onClicked: {
                                    //删除
                                    deleteItem(index)
                                }
                            }
                        }
                    }
                }

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    color = "#f0f0f0" //灰色

                }
                onExited: {
                    color = "#00000000"
                }
                onClicked: {
                    listViewDelegate.listView.view.currentIndex = index
                }
            }
        }
    }

    Component {
        id: listViewHeader
        Rectangle {
            color: "#00AAAA" //灰色
            height: 45
            width: listView.width
            RowLayout {
                width: parent.width
                height: parent.height
                spacing: 15
                x:5 //缩进，保证第一个元素不贴在里面
                Text {
                    text: "序号"
                    horizontalAlignment: Qt.AlignHCenter //居中
                    Layout.preferredWidth: parent.width*0.05
                    font.family: "宋体"
                    font.pointSize: 13
                    color: "white"
                    elide: Qt.ElideRight
                }
                Text {
                    text: "歌名"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.4
                    font.family: "宋体"
                    font.pointSize: 13
                    color: "white"
                    elide: Qt.ElideRight
                }
                Text {
                    text: "歌手"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: "宋体"
                    font.pointSize: 13
                    color: "white"
                    elide: Qt.ElideRight
                }
                Text {
                    text: "专辑"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: "宋体"
                    font.pointSize: 13
                    color: "white"
                    elide: Qt.ElideMiddle
                }
                Text {
                    text: "操作"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: "宋体"
                    font.pointSize: 13
                    color: "white"
                    elide: Qt.ElideRight
                }
            }
        }
    }

    Item {
        id: pageButton
        visible: musicList.length !== 0 && all!==0
        width: parent.width
        height: 40
        anchors.top: listView.bottom //紧贴
        anchors.topMargin: 20

        //同时只能选择一个
        ButtonGroup {
            buttons: buttons.children //重复点击不会再取消点击
        }
        RowLayout {
            id: buttons
            anchors.centerIn: parent
            Repeater {
                id: repeater
                model: 9 //all/pageSize>9?9:all/pageSize //最多显示9个
                Button {
                    Text {
                        anchors.centerIn: parent
                        text: modelData+1
                        font.family: "宋体"
                        font.pointSize: 14
                        color: checked?"#497563":"black"
                    }
                    background: Rectangle {
                        implicitHeight: 30
                        implicitWidth: 30
                        color: checked?"#e2f0f8":"#20e9f4ff"
                        radius: 3
                    }
                    checkable: true
                    checked: modelData === current
                    onClicked: {
                        if(current === index) return
                        //console.log("index:"+index)
                        //console.log("current:"+current)
                        current = index
                        loadMore(current*pageSize,index) //发送当前页数
                    }
                }
            }
        }
    }
/*
    function playMusic(index = 0) {
        //播放实现
        if(musicList.length<1) return

        var id = musicList[index].id
        if(!id) return //id不合法
        console.log("播放id:"+musicList[index].id)
        //song/detail?id=

        function onReply(reply) {
            http.onReplySignal.disconnect(onReply)
            var url = JSON.parse(reply).data[0].url
            if(!url) return
            mediaPlayer.source = url
            mediaPlayer.play()
            console.log("mediaPlayer.....Playing")
        }

        http.onReplySignal.connect (onReply)
        http.connet("song/url?id="+id)

    }
*/
}
