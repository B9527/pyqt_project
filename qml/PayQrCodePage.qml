import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    id: background1

    property int timer_value: 120
    property var qrCodePic

    //初始化页面
    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            abc.counter = timer_value
            my_timer.restart()
            slot_handler.in_scan_code_page()
            slot_handler.start_scan_qr_code()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
            slot_handler.out_scan_code_page()
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

    BackButton{
        id:develop_back_button
        x:365
        y:634
        show_text:qsTr("return")

        MouseArea {

            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
            }
            onEntered:{
                develop_back_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                develop_back_button.show_source = "img/button/7.png"
            }
        }
    }

    Image {
        id:ad_pic
        x: 330
        y: 270
        width: 350
        height: 350
        source: "code/" + qrCodePic
    }

    Text {
        id: qr_code_tips
        x: 165
        y: 153
        width: 680
        height: 48
        text: qsTr("please scan the code to pay")
        horizontalAlignment: Text.AlignHCenter
        font.family:"Microsoft YaHei"
        color:"#444586"
        font.pixelSize:45
        wrapMode: Text.WordWrap
    }

    Component.onCompleted: {
        root.pay_info_result.connect(pay_result)
    }

    Component.onDestruction: {
        root.pay_info_result.disconnect(pay_result)
    }


    function pay_result(text){
        switch(text){
            case "SUCCESS" : my_stack_view.push(customer_take_express_opendoor_view)//使用验证码正确，跳转到打开箱门界面
                break;
            case "FAIL" : my_stack_view.push(customer_take_express_error_view)//输入验证码不正确，跳转到输入验证码错误界面
                break;
            case "PAY_NET_ERROR" : pay_net_error.open()
                break;
            default : my_stack_view.push(customer_take_express_error_view)//其他情况以输入验证码不正确处理
            }
    }

    HideWindow{
        id:pay_net_error
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("pay_net_error")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:pay_net_error_back
            x:350
            y:560
            show_text:qsTr("back")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pay_net_error.close()
                    my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 2) return true }))
                }
                onEntered:{
                    pay_net_error_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    pay_net_error_back.show_source = "img/button/7.png"
                }
            }
        }
    }


}
