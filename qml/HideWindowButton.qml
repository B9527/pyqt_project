import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{

    width:220
    height:90
    color:"transparent"
    property var show_text:""
    property var show_source: "img/button/7.png"
    property var show_icon:""


    Image{
        width:180
        height:80
        source:show_source
    }

    Text {
        width: 180
        height: 80
        color:"white"
        text:show_text
        textFormat: Text.PlainText
        font.family: "Courier"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 30
    }
}
