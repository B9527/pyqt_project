import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    width:70
    height:70
    color:"transparent"
    property var show_text:""

    Image{
        id:letter_button_image
        width:70
        height:70
        source:"img/button/KeyButton_1.png"
    }

    Text{
        text:show_text
        color:"white"
        font.family:"Microsoft YaHei"
        font.pixelSize:24
        anchors.centerIn: parent;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            full_keyboard.letter_button_clicked(show_text)
        }
        onEntered:{
            letter_button_image.source = "img/button/Letterdown.png"
        }
        onExited:{
            letter_button_image.source = "img/button/KeyButton_1.png"
        }
    }


}
