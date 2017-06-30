import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{

    width:275
    height:120
    color:"transparent"

    property var show_text:""
    property var show_source:"img/button/7.png"


    //按钮蓝底
    Image{
        x:0
        y:0
        width:275
        height:120
        source:show_source
    }

    //文字组
    Rectangle{
        x:0
        y:0
        width:275
        height:120
        color:"transparent"

        //显示文字
        Text{
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text:show_text
            font.family:"Microsoft YaHei"
            color:"white"
            font.pixelSize:30
            anchors.centerIn: parent;
        }
    }


}
