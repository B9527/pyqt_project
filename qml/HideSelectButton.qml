import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{

    width:90
    height:50
    color:"transparent"
    property var show_text:""
    property var show_source: "img/button/7.png"
    property var show_icon:""


    Image{
        width:90
        height:50
        source:show_source
    }

    Text {
        width: 90
        height: 50
        color:"white"
        text:show_text
        textFormat: Text.PlainText
        font.family: "Courier"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 17
    }
}
