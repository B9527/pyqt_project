import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    id:floating_window

    //默认的让这个页面隐藏起来
    visible: false

    //模拟的一个遮罩
    Rectangle{
        x: 0
        y: 0
        width: 1024
        height: 768
        color: "#472f2f"
        opacity: 0.8

    }
    //模拟的窗口
    Rectangle{
        x: 90
        y: 200
        Image {
            id: image1
            x: 0
            y: 0
            width:860
            height: 500
            source: "img/courier13/layerground.png"
        }
    }
    function open(){
        floating_window.visible = true
    }
    function close(){
        floating_window.visible = false
    }
}
