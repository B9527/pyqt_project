import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    id:courier_memory_input
    property var show_text:""
    property int timer_value: 60
    property var press: "0"

    //判断进入当前页面是文本框是否为空，不是的将其清空
    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            if(courier_memory_input.show_text!=""){
                courier_memory_input.show_text=""
            }
            slot_handler.start_customer_scan_qr_code()
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            slot_handler.stop_customer_scan_qr_code()
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

    Component.onCompleted: {
        root.barcode_result.connect(handle_text)
        root.customer_store_express_result.connect(handle_user_info)
    }

    Component.onDestruction: {
        root.barcode_result.disconnect(handle_text)
        root.customer_store_express_result.disconnect(handle_user_info)
    }

    function handle_text(text){
        show_text = text
        customer_take_express_keyboard1.count = text.length
        my_stack_view.push(customer_confirm_send_express)
    }

    function handle_user_info(text){
        if(text == "False"){
            console.log("False")
        }else{
            my_stack_view.push(customer_confirm_send_express, {info:text})
        }
    }
    //文字
    Text{
        x:300
        y:120
        text:qsTr("Please scan or enter a tracking number")
        font.family:"Microsoft YaHei"
        width:280
        color:"#444586"
        font.pixelSize:45
    }

    //输入验证码的输入框
    Rectangle{

        x:220
        y:230
        width:620
        height:72
        color:"transparent"


        Image{
            width:620
            height:72
            source:"img/courier11/input.png"
        }
        TextEdit{
            y:10
            x:20
            font.family:"Microsoft YaHei"
            text:show_text
            color:"#444586"
            font.pixelSize:40
            anchors.left: parent;
        }


    }
    //二维码
    Rectangle{
        y:320
        x:340
        width:80
        height:80
        color:"transparent"


        Image{
            width:80
            height:80
            source:"img/courier11/QRcode.png"
        }



    }
    //条形码
    Rectangle{
        y:320
        x:470
        width:200
        height:72
        color:"transparent"

        Image{
            width:200
            height:72
            source:"img/courier11/DarCode.png"
        }



    }



    FullKeyboard{
        id:customer_take_express_keyboard1
        x:125
        y:415
        property var count:0
        property var validate_code:""

        Component.onCompleted: {
            customer_take_express_keyboard1.letter_button_clicked.connect(show_validate_code)
            customer_take_express_keyboard1.function_button_clicked.connect(on_function_button_clicked)

        }

        function on_function_button_clicked(str){
            if(str == "ok"){
                if(press != "0"){
                    return
                }
                press="1"
                slot_handler.stop_customer_scan_qr_code()
                slot_handler.start_get_customer_store_express_info(courier_memory_input.show_text)
            }

            if(str=="delete")
            {
                if(count>=20)
                {
                    count=19;
                }

            }

        }
        //获取快递单号
        function show_validate_code(str){
            if (str == "" && count > 0){
                if(count>=20)
                {
                    count=20
                }

                count--
                courier_memory_input.show_text=courier_memory_input.show_text.substring(0,count);
            }

            if (str != "" && count < 20){

                count++
            }
            if (count>=20){
                str=""
            }
            else{
                courier_memory_input.show_text += str

            }
            abc.counter = timer_value
            my_timer.restart()
        }
    }
}
