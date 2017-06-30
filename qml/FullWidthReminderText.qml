import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    width:1024
    height:40
    color:"transparent"
    property var remind_text:""
    property var remind_text_size:""
    Text{
        text:remind_text
        font.family:"Microsoft YaHei"
        color:"#444586"
        font.pixelSize:remind_text_size
        anchors.centerIn: parent;
    }
}
