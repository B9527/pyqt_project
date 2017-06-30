import QtQuick 2.4
import QtQuick.Controls 1.2
Rectangle{
    property var show_image_status
    property var show_image_size

    height: 60

    Image {
        id: image1
        width: 150
        height: 50
        source: show_image_status

        Text {
            id: text1
            x: 0
            y: 0
            width: 110
            height: 50
            text: show_image_status
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }
    }
    Image {
        id: image2
        x: 0
        y: 0
        width: 50
        height: 50
        source: show_image_size

        Text {
            id: text2
            width: 50
            height: 50
            text: "1"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }
    }
}
