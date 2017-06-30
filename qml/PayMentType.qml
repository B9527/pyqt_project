import QtQuick 2.4
import QtQuick.Controls 1.2

/*
功能：快件超免费时段支付类型26
author:caitao
*/
Rectangle{
    width:220
    height:245
    color:"transparent"

    property var show_text:""
    property var show_image:""
    property var show_x
    property var show_y
    property var box_x
    property var box_y

    Image{
        x:box_x
        y:box_y
        width:220
        height:245
        source:"img/05/button.png"
    }

    Rectangle{
        y:200
        width:220
        height:105
        color:"transparent"
        Image{
            x:show_x
            y:show_y
            width:170
            height:170
            source:show_image
        }
        Rectangle{
            y:190
            width:220
            height:30
            color:"transparent"
            Text{
                y:500
                text:show_text
                color:"white"
                font.family:"Microsoft YaHei"
                font.pixelSize:35
                anchors.centerIn: parent;
            }
        }
    }
}
