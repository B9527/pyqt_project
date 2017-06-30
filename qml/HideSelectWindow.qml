import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    id:hide_select_button_window

    //默认的让这个页面隐藏起来
    visible: false

    function open(){
        hide_select_button_window.visible = true
    }
    function close(){
        hide_select_button_window.visible = false
    }
}
