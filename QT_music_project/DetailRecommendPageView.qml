//推荐内容页面

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

//可以滚动
ScrollView {

    clip: true
    //如果超出区域，会自动裁剪
    ColumnLayout {

        Rectangle {
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("推荐音乐")
                font.family: "宋体"
                font.pointSize: 25
            }
        }

        MusicBannerView {
            id: bannerView
            Layout.preferredWidth:  window.width - 200
            Layout.preferredHeight: (window.width - 200) * 0.3
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("热门歌单")
                font.family: "宋体"
                font.pointSize: 25
            }
        }

        MusicGridHotView {
            id: hotView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width-250)*0.25*5+30*5+20 //四行五列
            Layout.bottomMargin: 20
            //Layout.preferredWidth:  window.width - 200
        }

        Rectangle {
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("新歌推荐")
                font.family: "宋体"
                font.pointSize: 25
            }
        }

        MusicGridLatestView {
            id: latestView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width-230)*0.1*10+20
            Layout.bottomMargin: 20
        }

        Component.onCompleted: {
            getBannerList()
        }

        function getBannerList() {
            function onReply(reply) {
                http.onReplySignal.disconnect(onReply)
                //把string转为jass
                var banners = JSON.parse(reply).banners
                bannerView.bannerList = banners
                //console.log("ba"+banners)
                getHotList()
            }
            http.onReplySignal.connect(onReply) //操作完之后，进行解绑
            //http.connet("banner") //不能打开这个，应该只能连接一个。
        }

        function getHotList() {
            function onReply(reply) {
                http.onReplySignal.disconnect(onReply)
                //把string转为jass
                var playlists = JSON.parse(reply).playlists
                //console.log(playlists)
                hotView.list=playlists
                getLatestList()
            }

            http.onReplySignal.connect(onReply) //操作完之后，进行解绑
            http.connet("top/playlist/highquality?limit=20")
        }

        //新歌
        function getLatestList() {
            function onReply(reply) {
                http.onReplySignal.disconnect(onReply)

                //把string转为jass
                var latestlists = JSON.parse(reply).data
                //console.log(playlists)
                latestView.list=latestlists.slice(0,30) //拿前30就可以了
                //console.log("list:::  "+latestlists.slice(0,30))
            }

            http.onReplySignal.connect(onReply) //操作完之后，进行解绑

            http.connet("top/song")
        }
    }
}
