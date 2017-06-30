import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    id:user_send_memory_input
    property var show_text:""
    property int timer_value: 60
    property var press: "0"
    property var show_text_count:0

    //判断进入当前页面是文本框是否为空，不是的将其清空
    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            if(user_send_memory_input.show_text!=""){
                user_send_memory_input.show_text=""
                show_text_count = 0
            }
            slot_handler.start_courier_scan_barcode()
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            slot_handler.stop_courier_scan_barcode()
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

Rectangle{
    id:main_page
    Component.onCompleted: {
        root.barcode_result.connect(handle_text)
        root.customer_reject_express_result.connect(handle_store_express_result)
    }

    Component.onDestruction: {
        root.barcode_result.disconnect(handle_text)
        root.customer_reject_express_result.disconnect(handle_store_express_result)
    }

    function handle_store_express_result(text){
        if(text != "False"){
            slot_handler.set_express_number(show_text)
            my_stack_view.push(reject_express_info, {send_data:text,memory:show_text})
        }
        else{
            main_page.enabled = false
            no_record.open()
        }
    }

    function handle_text(text){
        show_text = text
        customer_take_express_keyboard1.count = text.length
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

    Text{
        y:10
        x:20
        font.family:"Microsoft YaHei"
        text:show_text
        color:"#444586"
        font.pixelSize:40
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
        property var count:show_text_count
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
                press = "1"
                if(user_send_memory_input.show_text == ""){
                    main_page.enabled = false
                    error_tips.open()
                }
                else{
                    count = 0
                    slot_handler.start_get_customer_reject_express_info(show_text)
                }
            }

            if(str=="delete"){
                if(count>=20){
                    count=19
                }
            }
        }

        //获取快递单号
        function show_validate_code(str){
            if (str == "" && count > 0){
                if(count>=20){
                    count=20
                }

                count--
                user_send_memory_input.show_text=user_send_memory_input.show_text.substring(0,count);
            }

            if (str != "" && count < 20){
                count++
            }

            if (count>=20){
                str=""
            }
            else{
                user_send_memory_input.show_text += str
            }

            abc.counter = timer_value
            my_timer.restart()
        }

    }
}
    //输入空白时的提示
    HideWindow{
        id:error_tips
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("The memory is not input")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:ok_back
            x:350
            y:560
            show_text:qsTr("back")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    press = "0"
                    abc.counter = timer_value
                    my_timer.restart()
                    user_send_memory_input.show_text=""
                    show_text_count = 0
                    main_page.enabled = true
                    error_tips.close()
                }
                onEntered:{
                    ok_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    ok_back.show_source = "img/button/7.png"
                }
            }
        }
    }

    //未登记单号提示
    HideWindow{
        id:no_record
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("The memory is not defined")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:no_record_back
            x:350
            y:560
            show_text:qsTr("back")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    press = "0"
                    abc.counter = timer_value
                    my_timer.restart()
                    user_send_memory_input.show_text=""
                    show_text_count = 0
                    main_page.enabled = true
                    no_record.close()
                }
                onEntered:{
                    ok_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    ok_back.show_source = "img/button/7.png"
                }
            }
        }
    }
}
