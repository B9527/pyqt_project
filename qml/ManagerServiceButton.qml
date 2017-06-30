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
        width:220
        height:90
        source:show_source
    }

    Image {

        x: 16
        y: 18
        width: 60
        height: 60
        source: show_icon
    }

    Text {
        x: 80
        y: 21
        width: 120
        height: 50
        color:"white"
        text:show_text
        textFormat: Text.PlainText
        font.family: "Microsoft YaHei"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 30
    }
}
