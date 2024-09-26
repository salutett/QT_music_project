//跳转页面

import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12

RowLayout {

    id: page
    spacing: 0
    property int defaultIndex: 0

    property var qmlList: [

    {icon: "recommend-white",value:"推荐内容",qml: "DetailRecommendPageView",menu: true},
    {icon: "cloud-white",value:"搜索音乐",qml: "DetailSearchPageView",menu: true},
    {icon: "local-white",value:"本地音乐",qml: "DetailLocalPageView",menu: true},
    {icon: "history-white",value:"播放历史",qml: "DetailHistoryPageView",menu: true},
    {icon: "favorite-big-white",value:"我喜欢的",qml: "DetailFavoritePageView",menu: true},
    {icon: "",value:"124",qml: "DetailPlayListView",menu: false}
    ]

    Frame {
        Layout.preferredWidth: 200
        Layout.fillHeight: true
        background: Rectangle {
            color:  "#AA00AAAA" //透明颜色
        }
        padding: 0

        ColumnLayout {
            anchors.fill: parent

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                MusicBorderImage {
                    anchors.centerIn: parent //居中
                    height: 100
                    width: 100
                    borderRadius: 100 //圆角
                }
            }

            //列表
            ListView {
                id: menuView
                height: parent.height
                Layout.fillHeight: true
                Layout.fillWidth: true
                model: ListModel {
                    id: menuViewModel
                }
                delegate:menuViewDelegate //下面那个Component加载进来
                highlight: Rectangle {
                    color: "#aa73a7ab" //紫色
                }
                highlightMoveDuration: 400 //移动动画
                highlightResizeDuration: 0 //高亮有平滑的过度
            }
        }

        Component {
            id: menuViewDelegate
            Rectangle {
                id: menuViewDelegateItem
                height: 50
                width: 200
                color: "#AA00AAAA" //高亮
                RowLayout {
                    anchors.fill: parent
                    anchors.centerIn: parent
                    spacing: 15
                    Item {
                        width: 30
                    }

                    Image {
                        source: "qrc:/images/"+icon
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: 20
                    }

                    Text {
                        text: value
                        Layout.fillWidth: true
                        height: 50
                        font.family: "宋体"
                        font.pointSize: 12
                        color: "#ffffff"
                    }
                }

                //鼠标点击悬停
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        color = "#aa73a7ab"
                    }
                    onExited: {
                        color = "#AA00AAAA"
                    }

                    onClicked: {
                        hidePlayList()
                        repeater.itemAt(menuViewDelegateItem.ListView.view.currentIndex).visible = false
                        menuViewDelegateItem.ListView.view.currentIndex = index
                        var loader = repeater.itemAt(index)
                        loader.visible = true
                        loader.source = qmlList[index].qml + ".qml"
                    }
                }
            }
        }

        Component.onCompleted: {
            menuViewModel.append(qmlList.filter(item=>item.menu)) //使用定义的qmllist数组
            var loader = repeater.itemAt(defaultIndex)
            loader.visible = true
            loader.source = qmlList[defaultIndex].qml + ".qml"

            menuView.currentIndex = defaultIndex
            //showPlayList()
        }
    }

    //把子属性重复显示
    Repeater {
        id: repeater
        model: qmlList.length //如果menu为true
        Loader {
            visible: false
            Layout.fillHeight: true
            Layout.fillWidth: true

        }
    }

    function showPlayList(targetId = "",targetType = "10") {
        repeater.itemAt(menuView.currentIndex).visible = false
        var loader = repeater.itemAt(5)
        loader.visible = true
        loader.source = qmlList[5].qml + ".qml"
        loader.item.targetType = targetType
        loader.item.targetId = targetId
    }

    function hidePlayList() {
       repeater.itemAt(menuView.currentIndex).visible = true
        var loader = repeater.itemAt(5)
        loader.visible = false
    }

}

