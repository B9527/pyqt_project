import QtQuick 2.4
import QtQuick.Controls 1.2

// 调用background页面做背景
Background{
    id:user_send_memory_input
    property var show_text:""
    property int timer_value: 60
    property var press: "0"
    property var show_text_count:0

    //判断进入当前页面是文本框是否为空，不是的将其清空，开启扫描枪，离开页面关闭
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

//定义背景中的主界面
Rectangle{
    id:main_page
    function handle_text(text){
        show_text = text
        customer_take_express_keyboard1.count = text.length
    }

    //文字
    Text{
        x:210
        y:192
        text:qsTr("请输入您的用户名：")
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
        x: -8
        y: 41
        width:620
        height:72
        source:"img/courier11/input.png"
    }

    Text{
        y:46
        x:20
        font.family:"Microsoft YaHei"
        text:show_text
        color:"#444586"
        font.pixelSize:40
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
                    //console.log(timer_value)
                    slot_handler.start_set_username(show_text)
                    my_stack_view.push(send_input_memory_page)
                }
            }

            if(str=="delete"){
                if(count>=20){
                    count=19
                }
            }
        }

        //获取快递oa单号
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
            text: qsTr("未输入用户名，请重新输入")
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
    //无可用窗口提示
        HideWindow{
        id:nomouth_tips
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("抱歉，当前无可用窗口！")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        OverTimeButton{
            id:nomouth_back
            x:350
            y:560
            show_text:qsTr("返回")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    main_page.enabled = true
                    nomouth_tips.close()
                    //my_stack_view.push(send_input_memory_page)
                    my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
                }
                onEntered:{
                    nomouth_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    nomouth_back.show_source = "img/button/7.png"
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
            text: qsTr("OA错误，请重新输入")
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
    LoadingView{
        id:loading
    }
}
