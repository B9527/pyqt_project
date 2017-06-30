import QtQuick 2.4
import QtQuick.Controls 1.2

/*
功能：快件超免费时段页面05
author:caitao
parameter：payment（传入需要支付的金额）
*/

Background{
    id:over_time
    property var payment:"0.00"
    property var press: "0"
    property int timer_value: 60

    //打开该页面时，初始化按键底色
    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            over_time_button.show_source = "img/button/7.png"
            ok_button.show_source = "img/button/7.png"
            press = "0"
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
                abc.counter = 30
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



    Component.onCompleted: {
        root.overdue_cost_result.connect(process_result)
        slot_handler.customer_get_overdue_cost()
    }

    Component.onDestruction: {
        root.overdue_cost_result.disconnect(process_result)
    }

    function process_result(cost){
        over_time.payment = cost
    }

    FullWidthReminderText{
        y:250
        remind_text:qsTr("Your package has been more than a free pick-up time")
        remind_text_size:30
    }
    FullWidthReminderText{
        y:300
        remind_text:qsTr("If you want to take it, please pay")
        remind_text_size:30
    }
    FullWidthReminderText{
        y:400
        remind_text:qsTr("If you have any questions, please call 39043668")
        remind_text_size:30
    }
    FullWidthReminderText{
        x:-30
        y:350
        remind_text:payment
        remind_text_size:30
    }
    FullWidthReminderText{
        x:30
        y:350
        remind_text:qsTr("yuan")
        remind_text_size:30
    }

    //返回菜单按钮
    OverTimeButton{
        id:over_time_button
        x:200
        y:600
        show_text:qsTr("Back")
        show_x:0
        show_image:"img/05/back.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 1) return true }))
            }
            onEntered:{
                over_time_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                over_time_button.show_source = "img/button/7.png"
            }
        }
    }
    //确认，下一步按钮
    OverTimeButton{
        id:ok_button
        x:514
        y:600
        show_text:qsTr("OK")
        show_x:225
        show_image:"img/05/ok.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                my_stack_view.push(customer_take_express_payment_view)
            }
            onEntered:{
                ok_button.show_source = "img/button/7.png"
            }
            onExited:{
                ok_button.show_source = "img/bottondown/down_1.png"
            }
        }
    }

}
