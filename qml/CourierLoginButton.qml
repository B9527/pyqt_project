import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    width:100
    height:60
    property var show_image:""
    property var show_source:"img/courier08/08ground.png"
    color:"transparent"

    //按钮蓝底
    Image{
        x:0
        y:0
        width:100
        height:60
        source:show_source
    }

    Rectangle{
        y:15
        width:100
        height:30
        color:"transparent"

        Text{
            text:qsTr("登录")
            font.family:"Microsoft YaHei"
            color:"white"
            font.pixelSize:24
            anchors.centerIn: parent;
        }
    }




}
