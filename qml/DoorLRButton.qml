import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{

    width:370
    height:90
    color:"transparent"

    property var show_image:""


    //按钮蓝底
    Image{
        x:0
        y:0
        width:30
        height:30
        source:show_image
    }

}
