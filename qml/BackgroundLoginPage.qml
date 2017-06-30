import QtQuick 2.4
import QtQuick.Controls 1.2

Background{

    property var press:"0"
    property int timer_value: 60

    //一进入当前页面的时候判断文本框的内容是否为空，不是为空就将其清空
    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            courier_login_username.bool = true
            courier_login_psw.bool = false
            if(courier_login_username.show_text!=""||courier_login_psw.show_text!=""){
                courier_login_username.show_text=""
                courier_login_psw.show_text=""
                ch=1
            }
            courier_login_button.show_source = "img/courier08/08ground.png"
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
        x:50
        y:50
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


    property var identity:""
    //用于区分用户名密码的变量
    property var ch:1
Rectangle{
    id:main_page
    Component.onCompleted: {
        root.user_login_result.connect(handle_result)
    }

    Component.onDestruction: {
        root.user_login_result.disconnect(handle_result)
    }

    function handle_result(result){
        main_page.enabled = true
        loading.close()
        if(result == "Success"){
            if(identity == "LOGISTICS_COMPANY_USER"){
                my_stack_view.push(courier_service_view)
            }
            if(identity == "OPERATOR_USER"){
                my_stack_view.push(manager_service_view)
            }
        }
        if(result == "Failure"){
            my_stack_view.push(courier_psw_error_view)
        }
        if(result == "NoPermission"){
            my_stack_view.push(courier_psw_error_view)
        }
        if(result == "NetworkError"){
            main_page.enabled = false
            network_error.open()
            //    my_stack_view.push(courier_psw_error_view)
        }

    }



    CourierInput{
        id:courier_login_username
        x:150
        y:270
        show_image:"img/courier08/08user.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                ch=1
                courier_login_username.bool = true
                courier_login_psw.bool = false
            }
        }
    }

    CourierInputPsw{
        id:courier_login_psw
        x:455
        y:270
        show_image:"img/courier08/08pass.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                ch=2
                courier_login_username.bool = false
                courier_login_psw.bool = true
            }
        }
    }

    //登录按钮
    CourierLoginButton{
        id:courier_login_button
        x:760
        y:270
        MouseArea{
            anchors.fill:parent
            onClicked:{
                slot_handler.start_video_capture(identity + "_" + courier_login_username.show_text)
                if(press != "0"){
                    return
                }
                press = "1"
                slot_handler.background_login(courier_login_username.show_text,courier_login_psw.show_text,identity)
                main_page.enabled = false
                loading.open()
            }
            onEntered:{
                courier_login_button.show_source = "img/bottondown/login_down.png"
            }
            onExited:{
                courier_login_button.show_source = "img/courier08/08ground.png"
            }
        }
    }

    FullKeyboard{
        id:customer_take_express_keyboard
        x:125
        y:415
        property var count:0
        property var validate_c
        Component.onCompleted: {
            customer_take_express_keyboard.letter_button_clicked.connect(input_text)
            customer_take_express_keyboard.function_button_clicked.connect(on_function_button_clicked)
        }

        //点击对勾
        function on_function_button_clicked(str){
            abc.counter = timer_value
            if(str == "ok"){
                //如果在用户名输入框输入点击对勾就跳转到密码框
                if(ch == 1){

                    if(courier_login_username.show_text != "" && courier_login_psw.show_text != ""){
                        if(press!="0"){
                            return
                        }
                        press = "1"
                        abc.counter = timer_value
                        my_timer.stop()
                        slot_handler.background_login(courier_login_username.show_text,courier_login_psw.show_text,identity)
                        loading.open()
                        main_page.enabled = false
                    }else{
                        ch = 2
                        courier_login_username.bool = false
                        courier_login_psw.bool = true
                    }
                }else if(ch == 2){
                    if(courier_login_username.show_text != "" && courier_login_psw.show_text != ""){
                        if(press!="0"){
                            return
                        }
                        press = "1"
                        abc.counter = timer_value
                        my_timer.stop()
                        slot_handler.background_login(courier_login_username.show_text,courier_login_psw.show_text,identity)
                        loading.open()
                        main_page.enabled = false
                    }else{
                        ch = 1
                        courier_login_username.bool = true
                        courier_login_psw.bool = false
                    }
                }
            }
        }

        function input_text(str){
            abc.counter = timer_value
            my_timer.restart()
            //用户名
            if(ch==1){
                if (str == "" && courier_login_username.show_text.length > 0){
                    courier_login_username.show_text.length--
                    courier_login_username.show_text=courier_login_username.show_text.substring(0,courier_login_username.show_text.length-1 )
                }
                if (str != "" && courier_login_username.show_text.length< 14){
                    courier_login_username.show_text.length++
                }
                if (courier_login_username.show_text.length>=14){
                    str=""
                    courier_login_username.show_text.length=14
                }else{
                    courier_login_username.show_text += str
                }
            }

            //密码
            if(ch==2){
                if (str == "" && courier_login_psw.show_text.length > 0){
                    courier_login_psw.show_text.length--
                    courier_login_psw.show_text=courier_login_psw.show_text.substring(0, courier_login_psw.show_text.length-1)
                }
                if (str != "" && courier_login_psw.show_text.length < 14){
                    courier_login_psw.show_text.length++
                }
                if (courier_login_psw.show_text.length>=14){
                    str=""
                    courier_login_psw.show_text.length=14
                }else{
                    courier_login_psw.show_text += str
                }
            }
        }
    }
}

    //登录时，出现网络问题时的提示
    HideWindow{
        id:network_error
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("网络问题，请稍后重试！")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }

        //返回
        OverTimeButton{
            id:yse
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
                    network_error.close()
                }
                onEntered:{
                    yse.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    yse.show_source = "img/button/7.png"
                }
            }
        }
    }
    LoadingView{
        id:loading
    }
}
