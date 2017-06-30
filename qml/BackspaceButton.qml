import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    width:70
    height:70
    color:"transparent"

    Image{
        id:backspace_button_image
        width:70
        height:70
        source:"img/button/KeyButton_2.png"
    }

    Text{
        text:qsTr("backspace")
        color:"white"
        font.family:"Microsoft YaHei"
        font.pixelSize:24
        anchors.centerIn: parent;
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            my_stack_view.pop()
        }
        onEntered:{
            backspace_button_image.source = "img/button/Functiondown.png"
        }
        onExited:{
            backspace_button_image.source = "img/button/KeyButton_2.png"
        }
    }
}
