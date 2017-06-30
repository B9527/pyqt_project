import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    width:65
    height:65
    color:"transparent"
    property var slot_text:""
    property var show_image:""

    Image{
        id:function_button_Image
        width:65
        height:65
        source:"img/button/KeyButton_2.png"
    }
    Image{
        x:10
        y:16
        width:45
        height:30
        source:show_image
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(slot_text != "delete"){
                full_keyboard.function_button_clicked(slot_text)
            }
            else
                full_keyboard.letter_button_clicked("")
        }
        onEntered:{
            function_button_Image.source = "img/button/Functiondown.png"
        }
        onExited:{
            function_button_Image.source = "img/button/KeyButton_2.png"
        }
    }

}
