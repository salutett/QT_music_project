﻿//本地音乐页面

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.0
import Qt.labs.settings 1.1
import QtQml 2.3

ColumnLayout {

    Settings  {
        id: localSettings
        fileName: "conf/local.ini"
    }

    Rectangle {

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text {
            x: 10
            verticalAlignment: Text.AlignBottom
            text: qsTr("本地音乐")
            font.family: "宋体"
            font.pointSize: 25
        }
    }

    RowLayout {
        x: 10
        Item {
            width: 10
        }

        height: 80

        MusicTextButton {
            btnText: "添加本地音乐"
            btnWidth: 200
            btnHeight: 50
            onClicked: {
                fileDialog.open()
            }
        }
        MusicTextButton {
            btnText: "刷新记录"
            btnWidth: 120
            btnHeight: 50
            onClicked: {
                getLocal()
            }
        }
        MusicTextButton {
            btnText: "清空记录"
            btnWidth: 120
            btnHeight: 50
            onClicked: {
                saveLocal()
            }
        }
    }

    MusicListView {
        id: localListView
        onDeleteItem: deleteLocal(index)
    }

    Component.onCompleted: {
        getLocal()
    }

    function getLocal() {
        var list = localSettings.value("local",[])
        localListView.musicList = list
        return list
    }

    function clear() {
        localSettings.value("local",[]) //给它传空值
    }

    function saveLocal(list = []) {
        localSettings.setValue("local",list)
        getLocal()
    }

    function deleteLocal(index) {
        var list = localSettings.value("local",[])

        if(list.length<index+1) return
        list.splice(index,1)
        saveLocal(list)
    }

    FileDialog {
        id: fileDialog
        fileMode: FileDialog.OpenFiles
        nameFilters: ["MP3 Music Files(*mp3)","FLAC Music Files(*flac)"]
        folder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
        acceptLabel: "确定"
        rejectLabel: "取消"

        onAccepted: {
            var list = getLocal()
            for (var index in files) {
                var path = files[index]

                //var arr = files[index]
                var arr = path.split("/")
                var fileNameArr = arr[arr.length-1].split(".")
                //去掉后缀
                fileNameArr.pop()
                var fileName = fileNameArr.join(".")
                //歌手-名称.mp3
                var nameArr = fileName.split("-")
                var name = "海底世界"
                var artist = "海绵宝宝"
                if(nameArr.length>1) {
                    artist = nameArr[0]
                    console.log("art: "+artist)
                    nameArr.shift()
                }
                name = nameArr.join("-")
                console.log("name: "+name)
                if(list.filter(item=>item.id === path).length<1)
                list.push({
                          id: path+"",
                              name,artist,
                              url: path+"",
                              album: "本地音乐",
                              type: "1" //1表示本地，0表示网络
                          })
                saveLocal(list)
                //localListView.musicList = list
            }
        }
    }
}
