import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    id: background1
    property int timer_value: 60
    property var press: "0"
    property var store_type:"store"
    property variant containerqml: null

    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停�?
            my_timer.stop()
        }
    }
    /*
    定时�?
    30秒定时，时间到后自动跳转回菜单界�?
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
                    slot_handler.start_store_customer_reject_express()
                    my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
                }
            }
        }
    }

    //左右按钮
    DoorLRButton{
        y:207
        x:70
        show_image:"img/door/l1.png"
    }
    DoorLRButton{
        y:207
        x:920
        show_image:"img/door/r1.png"
    }

    //箱子�?门图�?
    DoorEvey{
        y:247
        x:60
    }
    //该界面的操作按钮
    DoorButton{
        id:help_button
        y:530
        x:660
        //   show_text:qsTr("Help")
        show_text:qsTr("re-open")
        show_image:"img/door/1.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
           /*     if(press != "0"){
                    return
                }
                press = "1"
                my_stack_view.push(user_select_view,{store_type:"store",containerqml:background1}) */
                slot_handler.start_open_mouth_again()
            }
            onEntered:{
                help_button.show_image = "img/door/down_1.png"
            }
            onExited:{
                help_button.show_image = "img/door/1.png"
            }
        }
    }

    DoorButton{
        id:back_button
        y:620
        x:60
        show_text:qsTr("Menu")
        show_image:"img/door/2.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                slot_handler.start_store_customer_reject_express()
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 1) return true }))
            }
            onEntered:{
                back_button.show_image = "img/door/down_2.png"
            }
            onExited:{
                back_button.show_image = "img/door/2.png"
            }
        }
    }
    DoorButton{
        id:again_button
        y:620
        x:360
        show_text:qsTr("Store packages again")
        show_image:"img/door/2.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                slot_handler.start_store_customer_reject_express()
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 2) return true }))
                //  my_stack_view.push(courier_memory_view)
            }
            onEntered:{
                again_button.show_image = "img/door/down_2.png"
            }
            onExited:{
                again_button.show_image = "img/door/2.png"
            }
        }
    }
    DoorButton{
        id:ok_button
        y:620
        x:660
        show_text:qsTr("Complete and exit")
        show_image:"img/door/2.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                slot_handler.start_store_customer_reject_express()
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
            }
            onEntered:{
                ok_button.show_image = "img/door/down_2.png"
            }
            onExited:{
                ok_button.show_image = "img/door/2.png"
            }
        }
    }

    Row {
        x: 93
        y: 165
        layoutDirection: Qt.LeftToRight

        Text {
            id: box_open_tips_1
            color: "#444586"
            text: qsTr("Please put the express into NO.")
            font.family:"Microsoft YaHei"
            font.pixelSize: 30
        }
        Text {
            id:mouth_number
            color: "#32adb1"
            text: qsTr("X")
            font.family:"Microsoft YaHei"
            font.pixelSize: 30
        }
        Text {
            id: box_open_tips_2
            color: "#444586"
            text: qsTr(",thank you")
            font.family:"Microsoft YaHei"
            font.pixelSize: 30
        }
    }

    Component.onCompleted: {
        root.mouth_number_result.connect(show_text)
        slot_handler.get_express_mouth_number()
    }

    Component.onDestruction: {
        root.mouth_number_result.disconnect(show_text)
    }

    function show_text(t){
        mouth_number.text = t
    }
    function clickedfunc(temp){
        containerqml.clickedfunc(temp)
    }

}
