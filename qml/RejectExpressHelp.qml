import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    /*
帮助页面17
*/
    property int timer_value: 60
    property var open_again_press: "0"
    property var change_press: "0"
    property var cancel_press: "0"
    property variant containerqml: null
    property var store_type: "store"

    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            open_again_press = "0"
            change_press = "0"
            cancel_press = "0"
            abc.counter = timer_value
            my_timer.restart()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
        }
    }

    /*
    定时器
    30秒定时，时间到后自动跳转回菜单界面
    */
    Rectangle{
        QtObject{
            id:abc
            property int counter
            Component.onCompleted:{
                abc.counter = timer_value
            }
        }

        Timer{
            id:my_timer
            interval:1000
            repeat:true
            running:true
            triggeredOnStart:true
            onTriggered:{
                abc.counter -= 1
                if(abc.counter < 0){
                    my_timer.stop()
                    my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
                }
            }
        }
    }

    //箱子开门图片
    //该界面的操作按钮

    Rectangle{
        Image {
            id: image1
            x: 95
            y: 259
            width: 865
            height: 1
            source: "img/courier19/stripe.png"
        }
    }

    Text {
        id: text4
        x: 431
        y: 488
        width: 428
        height: 88
        color:"#444586"
        text: qsTr("Have other question,please press the 'cancel' button and call us.")
        font.family:"Microsoft YaHei"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 30
    }

    Text {
        id: text5
        x: 431
        y: 391
        width: 428
        height: 88
        color:"#444586"
        text: qsTr("Package size is too large, please press the 'change-box' button.")
        verticalAlignment: Text.AlignVCenter
        font.family:"Microsoft YaHei"
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 30
    }

    Text {
        id: text6
        x: 431
        y: 291
        width: 428
        height: 88
        color:"#444586"
        text: qsTr("If the door is not open, please press the 're-open' button.")
        font.family:"Microsoft YaHei"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 30
    }

    //返回菜单按钮
    OverTimeButton{
        id:back_button
        x:90
        y:638
        width: 270
        height: 88
        show_text:qsTr("back to menu")
        show_x:15
        show_image:"img/05/back.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 3) return true }))
            }
            onEntered:{
                back_button.show_source = "img/05/pushdown.png"
            }
            onExited:{
                back_button.show_source = "img/05/button.png"
            }
        }
    }

    //重新开柜
    OverTimeButton {
        id:open_again_button
        x: 90
        y: 288
        width: 270
        height:85
        show_x: 15
        show_text: qsTr("re-open")

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(open_again_press != "0"){
                    return
                }
                open_again_press = "1"
                abc.counter = timer_value
                my_timer.restart()
                slot_handler.start_open_mouth_again()
            }
            onEntered:{
                open_again_button.show_source = "img/05/pushdown.png"
            }
            onExited:{
                open_again_button.show_source = "img/05/button.png"
            }
        }
    }
    //换柜
    OverTimeButton {
        id:change_box_button
        x: 90
        y: 388
        width: 270
        height:85
        show_x: 15
        show_text: qsTr("change-box")

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(change_press != "0"){
                    return
                }
                change_press = "1"
                containerqml.clickedfunc("change")
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 6) return true}))
            }
            onEntered:{
                change_box_button.show_source = "img/05/pushdown.png"
            }
            onExited:{
                change_box_button.show_source = "img/05/button.png"
            }
        }
    }
    //取消操作
    OverTimeButton {
        id:cancel_button
        x: 90
        y: 488
        width: 270
        height:85
        show_x: 15
        show_text: qsTr("cancel")

        MouseArea {
            anchors.bottomMargin: 14
            anchors.fill: parent
            onClicked: {
                if(cancel_press != "0"){
                    return
                }
                cancel_press = "1"
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 3) return true }))
            }
            onEntered:{
                cancel_button.show_source = "img/05/pushdown.png"
            }
            onExited:{
                cancel_button.show_source = "img/05/button.png"
            }
        }
    }

    Text {
        id: text7
        x: 95
        y: 171
        width:865
        height: 80
        color:"#444586"
        text: qsTr("You select the button, if you have the problem:")
        font.family:"Microsoft YaHei"
        font.pixelSize: 40
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
