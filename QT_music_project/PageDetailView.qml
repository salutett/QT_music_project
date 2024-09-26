//歌单详情页面

import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12

Item {
    Layout.fillHeight: true
    Layout.fillWidth:  true

    property alias lyrics : lyricView.lyrics
    property alias current : lyricView.current

    RowLayout {
        anchors.fill: parent
        Frame {
            Layout.preferredWidth: parent.width*0.45
            Layout.fillHeight: true

            Text {
                id: name
                text: layoutBottomView.musicName
                anchors {
                    bottom: artist.top
                    bottomMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font {
                    family: "宋体"
                    pointSize: 16
                }
            }

            Text {
                id: artist
                text: layoutBottomView.musicArtist
                anchors {
                    bottom: cover.top
                    bottomMargin: 50
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font {
                    family: "宋体"
                    pointSize: 12
                }
            }

            MusicBorderImage {
                id: cover
                anchors.centerIn: parent
                width: parent.width*0.6
                height: width
                borderRadius: width
                imgSrc: layoutBottomView.musicCover
                isRotating: layoutBottomView.playingState===1 //唱片转动
            }
        }

        Frame {
            Layout.preferredWidth: parent.width*0.55
            Layout.fillHeight: true

            MusicLyricView {
                id: lyricView
                anchors.fill: parent
            }
        }
    }
}
