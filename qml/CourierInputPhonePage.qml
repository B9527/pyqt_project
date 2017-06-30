import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    id:courier_input_phone
    property var show_text:""
    property int timer_value: 60
    property var press: "0"
    //定义接收传递输入电话号码信息的信号

    //一进入格口管理页面就加格口信息
    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            if(courier_input_phone.show_text!=""){
                courier_input_phone.show_text=""
            }
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
    //文字
    Text{
        x:120
        y:250
        font.family:"Microsoft YaHei"
        text:qsTr("Please enter customer phone number")
        width:280
        color:"#444586"
        font.pixelSize:45
    }
    //输入验证码的输入框
    Rectangle{
        x:120
        y:370
        width:420
        height:72
        color:"transparent"

        Image{
            width:420
            height:72
            source:"img/courier11/input.png"
        }

        TextEdit{
            id:input_phone
            text:show_text
            y:10
            x:30
            font.family:"Microsoft YaHei"
            color:"#444586"
            font.pixelSize:40
        }


    }
    //文字
    Text{
        x:120
        y:460
        font.family:"Microsoft YaHei"
        text:qsTr("The number will be used to receive the verification code and QR CODE")
        width:280
        color:"#444586"
        font.pixelSize:17
    }


    NumKeyboard{
        id:customer_take_express_keyboard
        x:650
        y:230
        property var count:0
        property var validate_code:""

        Component.onCompleted: {
            customer_take_express_keyboard.letter_button_clicked.connect(show_validate_code)
            customer_take_express_keyboard.function_button_clicked.connect(on_function_button_clicked)

        }

        function on_function_button_clicked(str){
            if(str == "ok"){
                if(press != "0"){
                    return
                }
                press = "1"
                if(courier_input_phone.show_text == ""){
                    main_page.enabled = false
                    error_tips.open()
                }
                else{
                    count=0
                    my_stack_view.push(courier_input_phone_sure_view,{show_text:courier_input_phone.show_text})
                }
            }
        }
        //得到输入的电话号码
        function show_validate_code(str){

            if (str == "" && count > 0){
                if(count>=15){
                    count=15
                }

                count--
                courier_input_phone.show_text=courier_input_phone.show_text.substring(0,count);
            }
            if(count==0){
                courier_input_phone.show_text=""
            }
            if (str != "" && count < 15){
                count++
            }
            if (count>=15){
                str=""
            }
            else{
                courier_input_phone.show_text += str
            }
            abc.counter = timer_value
            my_timer.restart()
        }
    }


    //返回菜单按钮
    OverTimeButton{
        id:input_phone_back_button
        x:200
        y:600
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
                input_phone_back_button.show_source = "img/05/pushdown.png"
            }
            onExited:{
                input_phone_back_button.show_source = "img/05/button.png"
            }
        }
    }
    //确认，下一步按钮
    OverTimeButton{
        id:input_phone_ok_button
        x:514
        y:600
        show_text:qsTr("ok")
        show_x:205
        show_image:"img/05/ok.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                if(courier_input_phone.show_text == ""){
                    main_page.enabled = false
                    error_tips.open()
                }
                else{
                    //点击确定按钮时拿到输入的电话号码，传给信号
                    my_stack_view.push(courier_input_phone_sure_view,{show_text:courier_input_phone.show_text})
                }
            }
            onEntered:{
                input_phone_ok_button.show_source = "img/05/pushdown.png"
            }
            onExited:{
                input_phone_ok_button.show_source = "img/05/button.png"
            }
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
        //关闭提示窗按钮
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

}
