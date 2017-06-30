import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    width:72
    height:72
    color:"transparent"
    property var show_text:""

    Image{
        width:72
        height:72
        source:"img/item/2.png"
    }
    Text{
        text:show_text
        color:"#444586"
        font.family:"Microsoft YaHei"
        font.pixelSize:45
        anchors.centerIn: parent;
    }


}