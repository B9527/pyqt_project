import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    property int timer_value: 60

    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            slot_handler.customer_scan_barcode_take_express()
            abc.counter = timer_value
            my_timer.restart()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            slot_handler.customer_cancel_scan_barcode()
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

    //扫描二维码的示意图
    Image{
        y:200
        width:473
        height:520
        source:"img/item/1.png"
    }

    Text{
        x:584
        y:290
        text:qsTr("Please open your QR code, \n the code sent by SMS \n to your mobile. Please QR \n code placed in front of the scan window \n 10cm Office")
        width:280
        color:"#444586"
        font.family:"Microsoft YaHei"
        font.pixelSize:30
    }

    Component.onCompleted: {
        root.customer_take_express_result.connect(log_text)
    }

    Component.onDestruction: {
        root.customer_take_express_result.disconnect(log_text)
    }

    function log_text(text){
        switch(text){
        case "Success" : my_stack_view.push(customer_take_express_opendoor_view)//使用验证码正确，跳转到打开箱门界面
            break;
        case "Overdue" : my_stack_view.push(customer_take_express_overtime_view)//输入验证码正确，但超出免费时段，跳转到提示界面
            break;
        case "Error" : my_stack_view.push(customer_take_express_error_view)//输入验证码不正确，跳转到输入验证码错误界面
            break;
        default : my_stack_view.pop()//其他情况以输入验证码不正确处理
        }
    }

    BackButton{
        id:back_button
        x:584
        y:630
        MouseArea {
            anchors.fill: parent
            onClicked: {
                my_stack_view.pop()
            }
            onEntered:{
                back_button.show_source = "img/door/down_2.png"
            }
            onExited:{
                back_button.show_source = "img/button/7.png"
            }
        }
    }

}
