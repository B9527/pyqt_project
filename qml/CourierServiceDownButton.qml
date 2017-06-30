import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{

    width:270
    height:100
    color:"transparent"

    property var show_text:""
    property var show_image:""
    property var show_source:"img/button/1.png"

    //按钮蓝底
    Image{
        x:0
        y:0
        width:275
        height:90
        source:show_source
    }

    //按钮图标
    Image{
        x:20
        y:10
        width:70
        height:70
        source:show_image
    }

    //文字组
    Rectangle{
        x:100
        y:30
        width:170
        height:30
        color:"transparent"

        //显示文字
        Text{
            text:show_text
            font.family:"Microsoft YaHei"
            color:"white"
            font.pixelSize:30
            anchors.centerIn: parent;
        }
    }


}
