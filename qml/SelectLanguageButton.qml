import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{

    width:275
    height:105
    color:"transparent"

    property var show_text:""
    property var show_source:"img/button/9.png"

    Image{
        id:select_language_button
        width:275
        height:105
        source:show_source
    }
    Rectangle{
        y:35
        width:275
        height:35
        color:"transparent"
        Text{
            font.family:"Microsoft YaHei"
            text:show_text
            color:"white"
            font.pixelSize:35
            anchors.centerIn: parent;
        }
    }

}
