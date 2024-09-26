//我喜欢页面

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.0
import QtQml 2.3

ColumnLayout {

    id: favorite111

    Rectangle {

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text {
            x: 10
            verticalAlignment: Text.AlignBottom
            text: qsTr("我喜欢的")
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
            btnText: "刷新记录"
            btnWidth: 120
            btnHeight: 50
            onClicked: {
                getFavorite()
            }
        }
        MusicTextButton {
            btnText: "清空记录"
            btnWidth: 120
            btnHeight: 50
            onClicked: {
                clearFavorite()
            }
        }
    }

    MusicListView {
        id: favoriteListView
        favotitable: false
        onDeleteItem: deleteFavorite(index)
    }

    Component.onCompleted: {
        getFavorite()
    }
    function getFavorite() {
        favoriteListView.musicList = favoriteSettings.value("favorite",[])
    }

    function clearFavorite() {
        favoriteSettings.setValue("favorite",[])
        getFavorite()
    }

    function deleteFavorite(index) {
        var list = favoriteSettings.value("favorite",[])

        if(list.length<index+1) return
        //console.log("16")
        list.splice(index,1)
        favoriteSettings.setValue("favorite",list)

        getFavorite()
    }
}

