import QtQuick 2.4
import QtQuick.Controls 1.2

/*
功能：快件超免费时段页面按钮05
author:caitao
*/
Rectangle{
    id: rectangle1

    width:275
    height:90
    color:"transparent"

    property var show_text:""
    property var show_image:""
    property var show_x
    property var show_source:"img/05/button.png"

    Image{
        width:275
        height:90
        source:show_source
    }
    Rectangle{
        id: rectangle2
        y:25
        width:275
        height:40
        color:"transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        Image{
            x:show_x
            width:40
            height:40
            source:show_image
        }
        Text{
            text:show_text
            anchors.horizontalCenterOffset: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color:"white"
            font.family:"Microsoft YaHei"
            font.pixelSize:35
        }
    }
}
