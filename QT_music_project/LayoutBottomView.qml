//歌曲导航

import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtMultimedia 5.0
import QtQml 2.12

//底部工具栏
Rectangle {

    property var playList: []
    property int current: -1

    property int sliderValue: 0
    property int sliderFrom: 0
    property int sliderTo: 100

    property int currentPlayMode: 0
    property var playModeList: [{icon: "single-repeat",name:"单曲循环"},
        {icon: "repeat",name: "顺序播放"},
        {icon: "random",name: "随机播放"}]


    property bool playbackStateChangeCallback: false
    property string musicName: "海底世界"
    property string musicArtist: "海绵宝宝"
    property string musicCover: "qrc:/images/player"

    property int playingState: 0

    id: layoutbottomview

    Layout.fillWidth: true
    height: 60
    color: "#00AAAA"

    RowLayout {
        anchors.fill: parent

        Item {
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true //可伸缩
        }

        MusicIconButton {
            icon.source: "qrc:/images/previous"
            iconWidth: 32
            iconHeight: 32
            toolTip: "上一曲"
            onClicked: playPrevious()
        }
        MusicIconButton {
            iconSource: playingState===0?"qrc:/images/stop":"qrc:/images/pause"
            iconWidth: 32
            iconHeight: 32
            toolTip: "暂停/播放"
            onClicked: {
                if(!mediaPlayer.source) return
                if(mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                    mediaPlayer.pause()
                }
                else if (mediaPlayer.playbackState === MediaPlayer.PausedState) {
                    mediaPlayer.play()
                }
            }
        }
        MusicIconButton {
            Layout.preferredWidth: 50
            icon.source: "qrc:/images/next"
            iconWidth: 32
            iconHeight: 32
            toolTip: "下一曲"
            onClicked: playNext("")
        }
        //进度条
        Item {
            Layout.preferredWidth: parent.width/2
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 25

            Text {
                id:nameText
                anchors.left: slider.left
                anchors.bottom: slider.top
                anchors.leftMargin: 5
                //text: "续加仪"
                text: musicName + "-" + musicArtist
                font.family: "宋体"
                color: "#ffffff"
            }

            Text {
                id:timeText
                anchors.right: slider.right
                anchors.bottom: slider.top
                anchors.rightMargin: 5
                //text:"00:00/05:30"
                font.family: "宋体"
                color: "#ffffff"
            }

            //进度条
            Slider {
                id:slider
                width: parent.width
                Layout.fillWidth: true

                value:sliderValue
                from: sliderFrom
                to:sliderTo

                //鼠标拖动滑动条
                onMoved: {
                    //if (mediaPlayer.MediaPlayerState === MediaPlayer.PlayingState)
                    mediaPlayer.seek(value)
                }

                height: 25
                background: Rectangle {
                    x: slider.leftPadding
                    y: slider.topPadding + (slider.availableHeight - height) / 2
                    width: slider.availableWidth
                    height: 4
                    radius: 2
                    color: "#e9f4ff"
                    Rectangle {
                        width: slider.visualPosition * parent.width
                        height: parent.height
                        color: "#73a7ab"
                        radius: 2
                    }
                }
                handle: Rectangle {
                    //x,y定位，居中
                    x: slider.leftPadding + (slider.availableWidth-width) * slider.visualPosition
                    y: slider.topPadding + (slider.availableHeight - height) / 2
                    width: 15
                    height: 15
                    radius: 5
                    color: "#f0f0f0" //灰色
                    border.color: "#73a7ab" //蓝色
                    border.width: 0.5
                }
            }
        }

//        MusicRoundImage {
//            id: musicCover
//            width: 50
//            height: 50
//        }

        //歌曲头像照片
        MusicBorderImage {
            imgSrc: musicCover
            width: 50
            height: 45

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                //scale是变小动画
                onPressed: {
                    musicCover.scale = 0.9
                }

                onReleased: {
                    musicCover.scale = 1.0
                }

                onClicked: {
                    pageDetailView.visible =! pageDetailView.visible
                    pageHomeView.visible =! pageHomeView.visible
                }
            }
        }

        MusicIconButton {
            Layout.preferredWidth: 50
            icon.source: "qrc:/images/favorite"
            iconWidth: 32
            iconHeight: 32
            toolTip: "我喜欢"
            onClicked: {
                saveFavorite(playList[current])
                //favorite111.getFavorite()
                //console.log("c: ",current)
                //saveFavorite(current)
            }

        }
        MusicIconButton {
            id: playMode
            Layout.preferredWidth: 50
            icon.source: "qrc:/images/"+playModeList[currentPlayMode].icon
            iconWidth: 32
            iconHeight: 32
            toolTip: playModeList[currentPlayMode].name
            onClicked: changePlayMode()
        }
        Item {
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
        }
    }

    Component.onCompleted: {
        //从配置文件中拿到currentPlayMode
        currentPlayMode = settings.value("currentPlayMode",0)
    }
    

    onCurrentChanged: {
        console.log("ff22")
        playbackStateChangeCallback = false
        playMusic(current)
    }

    //保存播放历史
    function saveHistory(index = 0) {
        //if()
        if(playList.length<index+1) return
        var item = playList[index]
        var history = historySettings.value("history",[])
        console.log("history: "+history)
        var name1 = item.name
        console.log("name1: "+item.name)
        var i = history.findIndex(value=>value.id===item.id)
        console.log("i: "+i)
        if(i>=0){
            history.splice(i,1) //指定删除

        }
        history.unshift({
                            id: item.id+"",
                            name: item.name,
                            artist: item.artist,
                            url: item.url?item.url: "",
                            type: item.type?item.type: "",
                            album: item.album?item.album: "本地音乐"
                        })
        if(history.length>100) {
            //限制100条
            history.pop()
        }
        historySettings.setValue("history",history)
    }

    //保存到我喜欢
    function saveFavorite(item={}) {
        //if()
        var favorite = favoriteSettings.value("favorite",[])
        //console.log("favorite: "+favorite)
        var name1 = item.name
        //console.log("name1: "+item.name)
        var i = favorite.findIndex(value=>value.id===item.id)
        //console.log("i: "+i)
        if(i>=0){
            favorite.splice(i,1) //指定删除

        }
        console.log("album: "+item.album)
        favorite.unshift({
                            id: item.id+"",
                            name: item.name,
                            artist: item.artist,
                            url: item.url?item.url: "",
                            type: item.type?item.type: "",
                            album: item.album?item.album: "本地音乐"
                        })
        if(favorite.length>500) {
            //限制500条
            favorite.pop()
        }
       favoriteSettings.setValue("favorite",favorite)
    }


    //上一曲
    function playPrevious() {
        
        if(playList.length<1) return
        //current = (current+playList.length-1)%playList.length
        switch (currentPlayMode) {
        case 0: //单曲循环
            if(type==='natural') {
                mediaPlayer.play()
                break
            }
        case 1: //顺序播放
            current = (current-1)%playList.length
            break
        case 2: //随机播放
            var random = parseInt (Math.random()*playList.length) //随机种子
            //如果current = random,random就+1，否则不变
            current = current === random?random - 1:random
            break
        }
    }
    
    //下一曲
    function playNext (type='natural') {
//        console.log("cc: "+current)
//        console.log("lgg: "+playList.length)
//        if(current===playList.length-1) {
//            current = -1
//        }
//        console.log("album2: "+playList[current].album)
//        console.log("name2: "+playList[current].name)

//        if(playList[current].album === "本地音乐") {
//            console.log("你好1")
//            var currentItem = playList[current]
//            mediaPlayer.source = currentItem.url
//        }


        if(playList.length<1) return
        switch (currentPlayMode) {
        case 0: //单曲循环
            if(type==='natural') {
                console.log("1213")

                mediaPlayer.play()
                break
            }
        case 1: //顺序播放
            current = (current+1)%playList.length
            break
        case 2: { //随机播放
            var random = parseInt (Math.random()*playList.length) //随机种子
            //如果current = random,random就+1，否则不变
            current = current === random?random + 1:random
            break
        }
        }

    }
    
    //切换播放模式
    function changePlayMode() {
        //console.log("::"+currentPlayMode)
        currentPlayMode = (currentPlayMode+1)%playModeList.length
        settings.setValue("currentPlayMode",currentPlayMode)
    }

    function playMusic(current) {
        console.log("curret: "+current)
        if(current<0) return
        //播放实现
        if(playList.length<current+1) return
        //获取播放链接
        if(playList[current].type==="1") {
            //播放本地音乐
            playLocalMusic()
        }
        else {
            //播放网络音乐
            console.log("d22")
            getUrl()
        }
        //保存此时播放歌曲
        saveHistory(current)
        //history11.getHistory()

//        getUrl()
    }

    function playLocalMusic() {
        var currentItem = playList[current]
        mediaPlayer.source = currentItem.url
        mediaPlayer.play()
        musicName = currentItem.name
        musicArtist = currentItem.artist
        //historyListView.musicList = historySettings.value("history",[])
        //history.getHistory()
    }

    function getUrl() {
        //console.log("aa:"+playList.length)
        if(playList.length<current+1) return

        var id = playList[current].id

        if(!id) return //id不合法

        //设置详情
        musicName = playList[current].name
        musicArtist = playList[current].artist
        console.log("name:"+musicName+"  artist:"+musicArtist)
        console.log("current:"+current)
        //nameText.text = playList[current].name+"/"+playList[current].artist
        console.log("播放id:"+playList[current].id)
        //song/detail?id=

        function onReply(reply) {

            http.onReplySignal.disconnect(onReply)

            var data = JSON.parse(reply).data[0]
            var url = data.url
            var time = data.time

            //设置slider进度条
            setSlider(0,time,0)

            console.log("g1")
            /* 有这个东西播放历史不能切换音乐，需要解决问题
            if(!url) return

            if(playList.length<current+1) return


            var cover = playList[current].cover
            if(cover.length<1) {
                //console.log("a")
                //请求cover
            getCover(id)
            } else{
                getLyric(id)
                musicCover= cover
            } */
            mediaPlayer.source = url
            mediaPlayer.play()
            console.log("mediaPlayer.....Playing+id:"+id)

            playbackStateChangeCallback = true
            //getCover(id)
            getLyric(id)  //先有这个才能使用播放历史
        }

        http.onReplySignal.connect (onReply)
        http.connet("song/url?id="+id)
        //http.connet("song/detail?ids"+id)
    }

    function getCover(id) {
        //获取id，得到歌曲名和歌手名
        function onReply(reply) {
            http.onReplySignal.connect (onReply)
            //请求歌词

            var song = JSON.parse(reply).songs[0]
            var cover = song.al.picUrl
            musicCover = cover
//            if(musicName.length<1)  musicName = song.name
//            if(musicArtist.length<1) musicArtist = song.ar[0].name

            musicName = song.name
            musicArtist = song.ar[0].name
            getLyric(id)
        }
        http.onReplySignal.connect (onReply)
        http.connet("song/detail?ids="+id)
    }

    function getLyric(id) {
        //获取id，得到歌曲名和歌手名
        function onReply(reply) {
            http.onReplySignal.connect (onReply)

            var lyric = JSON.parse(reply).lrc.lyric
            if(lyric.length<1) return
            //解析歌词
            var lyrics = (lyric.replace(/\[.*]/gi,"")).split("\n") //js语法替换掉[]以及里面的内容
            if(lyrics.length>0) pageDetailView.lyrics = lyrics
            //console.log(lyrics)
            var times = []
            lyric.replace(/\[.*\]/gi,function(match,index){
                //match : [00:00.00]
                //console.log("a11")
                //if(match.lenght>2){
                //console.log("a22")
                var time = match.substr(1,match.length-2)
                var arr = time.split(":")
                var timeValue = arr.length>0? parseInt(arr[0])*60*1000:0
                arr = arr.length>1?arr[1].split("."):[0,0]
                timeValue += arr.length>0?parseInt(arr[0])*1000:0
                timeValue += arr.length>1?parseInt(arr[1])*10:0
                times.push(timeValue)
                //console.log("qa+"+times)
                //}
            })
            //console.log("ti;:"+times)
            mediaPlayer.times = times
        }
        http.onReplySignal.connect (onReply)
        http.connet("lyric?id="+id)
    }

    function setSlider(from=0,to=100,value=0) {

        sliderFrom = from
        sliderTo = to
        sliderValue = value

        var va_mm = parseInt(value/1000/60) + "" //分钟数,转为字符串
        var va_ss = parseInt(value/1000%60) + "" //秒
        va_mm = va_mm.length<2?"0"+va_mm:va_mm //两位数
        va_ss = va_ss.length<2?"0"+va_ss:va_ss //两位数

        var to_mm = parseInt(to/1000/60) + "" //分钟数,转为字符串
        var to_ss = parseInt(to/1000%60) + "" //秒
        to_mm = to_mm.length<2?"0"+to_mm:to_mm //两位数
        to_ss = to_ss.length<2?"0"+to_ss:to_ss //两位数

        timeText.text = va_mm+":"+va_ss+"/"+to_mm+":"+to_ss
    }
}
