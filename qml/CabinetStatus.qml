import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    width:150
    height:50
    color:"transparent"
    property var show_status:""
    property var show_size:""
    property var show_image_status:"img/manage22/fulllocker.png"
    property var show_image_size:"img/manage22/c.png"

    Image {
        id: image1
        x: 0
        y: 0
        width: 100
        height: 50
        source: show_image_status

        Text {
            id: text1
            x: 0
            y: 0
            width: 110
            height: 50
            text:show_status
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }
    }

    Image {
        id: image2
        x: 100
        y: 0
        width: 50
        height: 50
        source: show_image_size

        Text {
            id: text2
            x: 0
            y: 0
            width: 50
            height: 50
            text:show_size
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }
    }
}
