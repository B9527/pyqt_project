import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    id:floating_window

    visible: false

    Rectangle{
        id: rectangle1
        x: 0
        y: 0
        width: 1024
        height: 768
        color: "#472f2f"
        opacity: 0.7


    }

    AnimatedImage  {
        id: loading_image
        x: 285
        y: 351
        height: 20
        anchors.verticalCenter: rectangle1.verticalCenter
        anchors.horizontalCenter: rectangle1.horizontalCenter
        source: "img/loading/loading.gif"
    }

    Text {
        id: loading_text
        x: 451
        y: 400
        color: "#444586"
        text: qsTr("Loading")
        font.family:"Microsoft YaHei"
        anchors.horizontalCenter: rectangle1.horizontalCenter
        font.pixelSize: 25
    }

    function open(){
        floating_window.visible = true
    }
    function close(){
        floating_window.visible = false
    }
}
