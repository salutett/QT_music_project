//搜索音乐页面

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true
    Rectangle {
        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text {
            x: 10
            verticalAlignment: Text.AlignBottom
            text: qsTr("搜索音乐")
            font.family: "宋体"
            font.pointSize: 25
        }
    }

    //搜索框
    RowLayout {

        Layout.fillWidth: true

        TextField {
            id: searchInput
            font.family: "宋体"
            font.pointSize: 14
            selectByMouse: true //可以选择
            selectionColor: "#999999" //黑色
            placeholderText: qsTr("请输入搜索关键词")
            color: "#000000" //透明
            background: Rectangle {
                color: "#00000000"
                border.width: 1
                opacity: 0.5 //不透明度
                implicitHeight: 40
                implicitWidth: 400
            }
            focus: true

            //快捷键
            Keys.onPressed: if(event.key===Qt.Key_Return)doSearch()
        }

        MusicIconButton {
            iconSource: "qrc:/images/search"
            toolTip: "搜索"
            onClicked: doSearch()
        }
    }

    MusicListView {
        id: musicListView
        deletable: false
        onLoadMore: doSearch(offset,current)
        Layout.topMargin: 10
    }

    function doSearch(offset = 0,current = 0) {
        var keywords = searchInput.text
        if(keywords.length<1) return
        function onReply(reply) {
            http.onReplySignal.disconnect(onReply)
            //把string转为jass
            var result = JSON.parse(reply).result
            musicListView.current = current
            musicListView.all = result.songCount
            musicListView.musicList = result.songs.map(item=>{
                                                    return {
                                                            id: item.id,
                                                            name: item.name,
                                                            artist: item.artists[0].name,
                                                            album: item.album.name,
                                                            cover: item.artists[0].img1v1Url
                                                        }
                                                    }) //格式化数据
            //bannerView.bannerList = banners
        }
        http.onReplySignal.connect(onReply) //操作完之后，进行解绑
        http.connet("search?keywords="+keywords+"&offset="+offset+"&limit=60")
    }
}


