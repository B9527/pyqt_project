import QtQuick 2.4
import QtQuick.Controls 1.2


//返回按钮
Rectangle{

    width:280
    height:80
    color:"transparent"

    property var show_text:qsTr("Back")
    property var show_source:"img/button/7.png"

    Image{
        width:280
        height:80
        source:show_source
    }

    Image{
        x:15
        y:20
        width:40
        height:40
        source:"img/button/8.png"
    }

    Rectangle{
        y:25
        width:280
        height:30
        color:"transparent"

        Text{
            font.family:"Microsoft YaHei"
            text:show_text
            color:"white"
            font.pixelSize:24
            anchors.centerIn: parent;
        }
    }
}

