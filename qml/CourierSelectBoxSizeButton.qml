import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{

    width:140
    height:140
    color:"transparent"

    property var show_text:""
    property var show_image:""
    property var show_source:""


    //按钮蓝底
    Image{
        x:0
        y:0
        width:140
        height:140
        //source:"img/courier14/14ground.png"
        source:show_source
    }

    //按钮图标
    Image{
        x:15
        y:15
        width:110
        height:110
        source:show_image
    }

    Text{
        text:show_text
        color:"white"
        font.family:"Microsoft YaHei"
        font.pixelSize:30
        anchors.centerIn: parent;
    }


}
