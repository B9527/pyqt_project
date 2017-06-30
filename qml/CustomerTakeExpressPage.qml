import QtQuick 2.4
import QtQuick.Controls 1.2

Background{

    property var press:"0"
    property int timer_value: 60
    property var pic

    //初始化页面
    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            if(first_validate_code_box.show_text != ""){
                first_validate_code_box.show_text = ""
                second_validate_code_box.show_text = ""
                third_validate_code_box.show_text = ""
                fourth_validate_code_box.show_text = ""
                fifth_validate_code_box.show_text = ""
                sixth_validate_code_box.show_text = ""
                customer_take_express_keyboard.count = 0
            }
            loading.close()
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
            root.customer_take_express_result.connect(process_result)
        	//root.qr_code_pic_result.connect(set_pic)
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
            root.customer_take_express_result.disconnect(process_result)
        	//root.qr_code_pic_result.disconnect(set_pic)
        }
    }

    ValidateCodeBox{
        id:first_validate_code_box
        x:275
        y:245
    }

    ValidateCodeBox{
        id:second_validate_code_box
        x:355
        y:245
    }

    ValidateCodeBox{
        id:third_validate_code_box
        x:435
        y:245
    }

    ValidateCodeBox{
        id:fourth_validate_code_box
        x:515
        y:245
    }

    ValidateCodeBox{
        id:fifth_validate_code_box
        x:595
        y:245
    }

    ValidateCodeBox{
        id:sixth_validate_code_box
        x:675
        y:245
    }

    Component.onCompleted: {
        
    }

    Component.onDestruction: {
        
    }

    function set_pic(text){
        pic = text
    }

    //根据返回的值判断跳转到哪个页面
    function process_result(text){
        //text="Success"
        switch(text){
        case "Success" : my_stack_view.push(customer_take_express_opendoor_view)//使用验证码正确，跳转到打开箱门界面
            break;
        case "Error" : my_stack_view.push(customer_take_express_error_view)//输入验证码不正确，跳转到输入验证码错误界面
            break;

        default : my_stack_view.push(customer_take_express_error_view)//其他情况以输入验证码不正确处理
        }
    }

    FullKeyboard{
        id:customer_take_express_keyboard
        x:125
        y:415
        property var count:0
        property var validate_code:""

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
            customer_take_express_keyboard.letter_button_clicked.connect(show_validate_code)
            customer_take_express_keyboard.function_button_clicked.connect(on_function_button_clicked)
        }

        Component.onDestruction: {
            customer_take_express_keyboard.letter_button_clicked.disconnect(show_validate_code)
            customer_take_express_keyboard.function_button_clicked.disconnect(on_function_button_clicked)
        }

        function on_function_button_clicked(str){


            if(str == "ok"){
                if(press != "0"){
                    return
                }
                press="1"
                my_timer.stop()
                validate_code = ""
                validate_code += first_validate_code_box.show_text
                validate_code += second_validate_code_box.show_text
                validate_code += third_validate_code_box.show_text
                validate_code += fourth_validate_code_box.show_text
                validate_code += fifth_validate_code_box.show_text
                validate_code += sixth_validate_code_box.show_text
                slot_handler.start_video_capture("enduser" + "_" + validate_code)
                slot_handler.customer_take_express(validate_code)
                loading.open()
            }
        }

        function show_validate_code(str){
            if (str == "" && count > 0){
                count--
            }
            if (count == 0){
                first_validate_code_box.show_text = str
            }
            if (count == 1){
                second_validate_code_box.show_text = str
            }
            if (count == 2){
                third_validate_code_box.show_text = str
            }
            if (count == 3){
                fourth_validate_code_box.show_text = str
            }
            if (count == 4){
                fifth_validate_code_box.show_text = str
            }
            if (count == 5){
                sixth_validate_code_box.show_text = str
            }
            if (str != "" && count < 6){
                count++
            }
            abc.counter = timer_value
            my_timer.restart()
        }
    }

    FullWidthReminderText {
        x: 0
        y: 350
        remind_text:qsTr("请输入短信验证码 (6 位字母和数字组合)")
        remind_text_size:"30"
    }
    LoadingView{
        id:loading
    }

}
