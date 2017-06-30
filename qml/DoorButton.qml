import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{

    width:290
    height:70
    color:"transparent"

    property var show_text:""
    property var show_image:""


    //按钮蓝底
    Image{
        x:0
        y:0
        width:290
        height:70
        source:show_image
    }



    //文字组
    Rectangle{
        width:290
        height:70
        color:"transparent"

        //显示文字
        Text{
            text:show_text
            color:"white"
            font.family:"Microsoft YaHei"
            font.pixelSize:24
            anchors.centerIn: parent;
        }
    }


}
