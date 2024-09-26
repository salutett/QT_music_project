//MusicBannerView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQml 2.12
//import "PageHomeView.qml"

//带边框
Frame {

    property int current: 0
    //property var bannerList: []
    function y1()
    {
        console.log("11")
    }

    property alias bannerList : bannerView.model
    background: {
        color: "#00000000"
    }

    PathView {
        id: bannerView
        width: parent.width
        height: parent.height

        clip: true
//        model: []
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            //在这个区域
            onEntered: {
                bannerTimer.stop()
            }
            onExited: {
                bannerTimer.start()
            }
        }
        delegate: Item {
            id: delegateItem
            width: bannerView.width*0.7
            height: bannerView.height
            z: PathView.z?PathView.scale: 0
            scale: PathView.scale?PathView.scale: 1.0

            MusicRoundImage {

                id: image
                imgSrc: modelData.imageUrl
                width: delegateItem.width
                height: delegateItem.height
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if(bannerView.currentIndex===index){
                        var item = bannerView.model[index]
                        var targetId = item.targetId + "" //转为字符串
                        var targetType = item.targetType + ""//1:单曲;10:专辑;3000:歌单
                        console.log("id+type::"+targetId,targetType)
                        switch(targetType) {
                        case "1":
                            //播放歌曲
                            layoutBottomView.current = -1
                            layoutBottomView.playList = [{id: targetId,name:"",artist: "",cover: "",album: ""}]
                            layoutBottomView.current = 0
                            break
                        case "10":
                            page.showPlayList(targetId,targetType)
                            //打开专辑
                            break
                        case "1000":
                            //打开播放列表
                            page.showPlayList(targetId,targetType)
                            break
                        }
                        //console.log(targetId,targetType)
                    }
                    else {
                        bannerView.currentIndex = index
                    }
                }
            }
        }

        pathItemCount:  3
        path: bannerPath

        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
    }

    Path {
        id: bannerPath
        startX: 0
        startY: bannerView.height/2 - 10

        PathAttribute{name:"z";value:0}
        PathAttribute{name:"scale";value:0.6}

        PathLine {
            x: bannerView.width/2
            y: bannerView.height/2 - 10
        }

        PathAttribute{name:"z";value:2}
        PathAttribute{name:"scale";value:0.85}

        PathLine {
            x: bannerView.width
            y: bannerView.height/2 - 10
        }

        PathAttribute{name:"z";value:0}
        PathAttribute{name:"scale";value:0.6}
    }

    PageIndicator {
        id: indicitor
        anchors {
            top: bannerView.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: -10
        }
        count: bannerView.count
        currentIndex: bannerView.currentIndex
        spacing: 10
        delegate: Rectangle {
            width: 20
            height: 5
            radius: 5
            color: index===bannerView.currentIndex?"balck":"gray"
            Behavior on color {

                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                //在这个区域
                onEntered: {
                    bannerView.currentIndex = index
                    bannerTimer.stop()
                }
                onExited: {
                    bannerTimer.start()
                }
            }
        }
    }

    Timer {
        id: bannerTimer
        running: true
        repeat: true
        interval:3000 //3s
        onTriggered: {
            if(bannerView.count>0)
                bannerView.currentIndex=(bannerView.currentIndex+1)%bannerView.count
        }
    }

    /* 这是轮播图实现方式
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: {
            bannerTimer.stop()
        }
        onExited: {
            bannerTimer.start()
        }

    }

    MusicRoundImage {
        id: leftImage
        width: parent.width*0.6
        height: parent.height*0.8
        anchors {
            left: parent.left
            bottom: parent.bottom
            bottomMargin: 20
        }
        imgSrc: getLeftImgSrc()

        //资源改变时
        onImgSrcChanged: {
            leftImageAnim.start()
        }

        NumberAnimation {
            id: leftImageAnim
            target: centerImage
            property: "scale" //缩放
            from: 0.8
            to: 1.0
            duration: 200
        }
        //推荐图片点击事件
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if(bannerList.length>0)
                    current = current==0?bannerList.length-1:current-1
            }
        }
    }

    MusicRoundImage {
        id: centerImage
        width: parent.width*0.6
        height: parent.height
        anchors.centerIn: parent
        z: 2 //垂直于屏幕
        imgSrc: getCenterImgSrc()

        onImgSrcChanged: {
            centerImageAnim.start()
        }
        NumberAnimation {
            id: centerImageAnim
            target: centerImage
            property: "scale" //缩放
            from: 0.8
            to: 1.0
            duration: 200
        }

        //推荐图片点击事件
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
        }
    }

    MusicRoundImage {
        id: rightImage
        width: parent.width*0.6
        height: parent.height*0.8
        anchors {
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 20
        }
        imgSrc: getRightImgSrc()

        NumberAnimation {
            id: rightImageAnim
            target: centerImage
            property: "scale" //缩放
            from: 0.8
            to: 1.0
            duration: 200
        }
        onImgSrcChanged: {
            rightImageAnim.start()
        }

        //推荐图片点击事件
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if(bannerList.length>0)
                    current = current==bannerList.length-1?0:current+1
            }
        }
    }

    PageIndicator {
        anchors {
           top: centerImage.bottom
           horizontalCenter: parent.horizontalCenter
        }
        count: bannerList.length
        interactive: true
        onCurrentIndexChanged: {
            current =currentIndex
        }
        delegate: Rectangle {
            width: 20
            height: 5
            radius: 5
            color: current===index?"black":"gray"

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {
                    bannerTimer.stop()
                    current = index
                }
                onExited: {
                    bannerTimer.start()
                }
            }
        }
    }

    Timer {
        id: bannerTimer
        running: true
        interval:5000 //5s
        repeat: true //重复执行
        onTriggered: {
            if(bannerList.length>0)
                current = current==bannerList.length-1?0:current+1
        }
    }

    function getLeftImgSrc() {
        return bannerList.length?bannerList[(current-1 + bannerList.length)%bannerList.length].imageUrl: ""
    }
    function getCenterImgSrc() {
        return bannerList.length?bannerList[current].imageUrl: ""
    }
    function getRightImgSrc() {
        return bannerList.length?bannerList[(current+1 + bannerList.length)%bannerList.length].imageUrl: ""
    }*/
}
