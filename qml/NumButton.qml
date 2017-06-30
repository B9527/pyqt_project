import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    width:100
    height:75
    color:"transparent"
    property var show_text:""

    Image{
        id:num_button
        width:100
        height:75
        source:"img/button/NumKeyButton_1.png"
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
            num_button.source = "img/bottondown/numbuttondown.png"
        }
        onExited:{
            num_button.source = "img/button/NumKeyButton_1.png"
        }
    }

}
