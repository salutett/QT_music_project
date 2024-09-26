import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import MyUtils 1.0
import QtMultimedia 5.12
import Qt.labs.settings 1.1

ApplicationWindow {
    id: window

    property int mWINDOW_WIDTH: 1200
    property int mWINDOW_HEIGHT: 800

    property string mFONT_FAMILY: "宋体"
    visible: true
    width: mWINDOW_WIDTH
    height: mWINDOW_HEIGHT
    title: qsTr("Demo Cloud Music Player")

    function q() {
        console.log("1233")
    }

    background: Background {
        id: appBackground
    }

    HttpUtils {
        id: http
    }

    //注册
    Settings {
        id: settings
        fileName: "conf/settings.ini"
    }

    Settings  {
        id: historySettings
        fileName: "conf/history.ini"
    }

    Settings {
        id: favoriteSettings
        fileName: "conf/favorite.ini"
    }

    Component.onCompleted: {
        textHttp()
    }

    function textHttp() {
        function onReply(reply) {
            console.log(reply)
            http.onReplySignal.disconnect(onReply)
        }

        http.onReplySignal.connect(onReply) //操作完之后，进行解绑
        http.connet("banner")
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        LayoutHeaderView {
            id: layoutHeaderView
        }

        PageHomeView {
            id: pageHomeView
        }

        PageDetailView {
            id: pageDetailView
            visible: false
        }

        LayoutBottomView {
            id: layoutBottomView
        }
    }

    MediaPlayer {
        id: mediaPlayer

        property var times: []

        onPositionChanged: {
            layoutBottomView.setSlider(0,duration,position)

            //console.log("times...",times.length,position)
            if(times.length>0) {
               // pageDetailView.current = times.filter(time=>time<position).length
                var count = times.filter(time=>time<position).length
                pageDetailView.current = (count===0)?0:count-1
            }
        }

        //监听事件，一首歌播放完自动切换
        onPlaybackStateChanged: {
            layoutBottomView.playingState = playbackState === MediaPlayer.PlayingState? 1:0
            if(playbackState===MediaPlayer.StoppedState && layoutBottomView.playbackStateChangeCallback) {
                console.log("1234")
                layoutBottomView.playNext()
            }
            console.log("playbackState...",playbackState === MediaPlayer.StoppedState)
        }

    }
}
