//专辑歌单页面

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ColumnLayout {

    property string targetId: ""
    property string targetType: "10" //专辑或歌单
    property string name: "-"

    onTargetIdChanged:  {
        if(targetType=="10") loadAlbum()
        else if(targetType=="3000") loadPlayList()

    }

//        //if(targetId.length<1) return
//        var url = (topgetType=="10"?"album":"playlist/detail")+"?id"+(targetId.length<1?"32311":targetId)

//    }
    Rectangle {
        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text {
            x: 10
            verticalAlignment: Text.AlignBottom
            text: qsTr(targetType=="10"?"专辑":"歌单") + name
            font.family: "宋体"
            font.pointSize: 25
        }
    }

    RowLayout {
        height: 200
        width: parent.width
        MusicBorderImage {
            id: playListCover
            width: 180
            height: 180
            Layout.leftMargin: 15
        }

        Item {
            Layout.fillWidth: true
            height: parent.width

            Text {
                id: playListDesc
                width: parent.width*0.95
                //text:  "你好"
                anchors.centerIn: parent
                wrapMode: Text.WrapAnywhere
                font.family: "宋体"
                font.pointSize: 14
                maximumLineCount: 4 //4行
                lineHeight: 1.5

            }
        }
    }

    MusicListView {
        id: palyListListView
        deletable: false
    }


    function loadAlbum() {
        var url = "album?id="+(targetId.length<1?"32311":targetId)

        function onReply(reply) {
            http.onReplySignal.disconnect(onReply)
            //把string转为jass
            var album = JSON.parse(reply).album
            var songs = JSON.parse(reply).songs
            playListCover.imgSrc = album.blurPicUrl
            playListDesc.text = album.description
            name = "-"+album.name

            palyListListView.musicList= songs.map(item=>{
                                                      return {
                                                          id: item.id,
                                                          name: item.name,
                                                          artist: item.ar[0].name,
                                                          album: item.al.name,
                                                          cover: item.al.picUrl
                                                      }
                                                  })

        }
        http.onReplySignal.connect(onReply)
        http.connet(url)
    }

    function loadPlayList() {
        var url = "playlist/detail?id="+(targetId.length<1?"32311":targetId)

        function onSongDetailReply(reply) {
            http.onReplySignal.disconnect(onReply)
            //把string转为jass
            var songs = JSON.parse(reply).songs

            console.log("2c")
            palyListListView.musicList= songs.map(item=>{
                                                      return {
                                                          id: item.id,
                                                          name: item.name,
                                                          artist: item.ar[0].name,
                                                          album: item.al.name,
                                                          cover: item.al.picUrl
                                                      }
                                                  })

        }

        function onReply(reply) {
            http.onReplySignal.disconnect(onReply)
            var playlist = JSON.parse(reply).playlist
            playListCover.imgSrc = playlist.coverImgUrl
            playListDesc.text = playlist.description
            name = "-"+playlist.name

            var ids = playlist.trackIds.map(item=>item.id).join(",") //把字符插入字符串连接起来

            http.onReplySignal.connect(onSongDetailReply)
            http.connet("song/detail?ids="+ids)
        }
        http.onReplySignal.connect(onReply)
        http.connet(url)
    }
}
