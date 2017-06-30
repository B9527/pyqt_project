import QtQuick 2.4
import QtQuick.Controls 1.2

Background{

    property var press:0
    property int timer_value: 10

    //初始化页面
    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            select_first_button.show_source = "img/button/9.png"
            select_second_button.show_source = "img/button/9.png"
            press = 0   //页面内按钮是否可以点击，0为可以被点击，1为不可以被点击
            abc.counter = timer_value
            my_timer.restart()
            slot_handler.in_main_page()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
            slot_handler.quit_main_page()
        }
    }

    FullWidthReminderText{
        y:310
        remind_text:qsTr("display please select your language use first language")
        remind_text_size:45
    }

    FullWidthReminderText{
        y:350
        remind_text:qsTr("display please select your language use second language")
        remind_text_size:24
    }

    SelectLanguageButton{
        id:select_first_button
        x:235
        y:455
        show_text:qsTr("main language")

        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press==0){
                    slot_handler.select_language("first.qm")
                    my_stack_view.push(select_service_view)
                    //my_stack_view.push(user_select_express_page)
                    press=1
                    slot_handler.clean_user_token()
                }
            }
            onEntered:{
                select_first_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                select_first_button.show_source = "img/button/9.png"
            }
        }
    }

    SelectLanguageButton{
        id:select_second_button
        x:514
        y:455
        show_text:qsTr("second language")

        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press==0){
                    slot_handler.select_language("second.qm")
                    my_stack_view.push(select_service_view)
                    press=1
                    slot_handler.clean_user_token()
                }
            }
            onEntered:{
                select_second_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                select_second_button.show_source = "img/button/9.png"
            }
        }
    }

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
}
