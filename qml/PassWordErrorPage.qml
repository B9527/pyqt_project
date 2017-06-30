import QtQuick 2.4
import QtQuick.Controls 1.2

/*
功能：验证码不正确页面07
author:caitao
*/

Background{
    property int timer_value: 60

    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
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

    Row {
        x: 275
        y: 245
        width: 72
        height: 72
        spacing: 8
        z: 0
        scale: 1
        opacity: 1

        Image {
            id: error_1
            width: 72
            height: 72
            source: "img/07/password.png"
        }

        Image {
            id: error_2
            width: 72
            height: 72
            source: "img/07/password.png"
        }

        Image {
            id: error_3
            width: 72
            height: 72
            source: "img/07/password.png"
        }

        Image {
            id: error_4
            width: 72
            height: 72
            source: "img/07/password.png"
        }

        Image {
            id: error_5
            width: 72
            height: 72
            source: "img/07/password.png"
        }

        Image {
            id: error_6
            width: 72
            height: 72
            source: "img/07/password.png"
        }
    }

    //文字说明
    FullWidthReminderText{
        id:text
        y:350
        remind_text:qsTr("验证码不正确，请重新输入！")
        remind_text_size:40
    }

    //返回重新輸入按鈕
    OverTimeButton{
        id:pass_error_button
        x:375
        y:478
        show_text:qsTr("重新输入")
        show_x:38
        show_image:"img/07/rewrite.png"

        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                my_stack_view.pop()
            }
            onEntered:{
                pass_error_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                pass_error_button.show_source = "img/05/button.png"
            }
        }
    }


}
