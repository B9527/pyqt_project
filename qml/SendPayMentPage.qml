import QtQuick 2.4
import QtQuick.Controls 1.2

/*
功能：快件超免费时段支付页面26
author:caitao
*/

Background{

    property int timer_value: 60
    property var press: "0"
    property string designationSize: "S"

    //页面启动时，初始化
    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            octopus.show_source = "img/button/1.png"
            coin.show_source = "img/button/1.png"
            app.show_source = "img/button/1.png"
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

    //文字说明
    Column{
        x:118
        y:190

        //文字说明
        FullWidthReminderText{
            width: 800
            transformOrigin: Item.Center
            //remind_text:qsTr("Please select the type of payment")
            remind_text:qsTr("Please choose the method of payment")
            remind_text_size:"40"
        }
        FullWidthReminderText{
            width: 800
            //remind_text:qsTr("If you have any questions, please call 888888")
            remind_text:qsTr("If you have any questions, please contact ********")
            remind_text_size:"30"
        }
    }
    //使用八达通
    SelectServiceButton{
        id:octopus
        x:160
        y:300
        show_text:qsTr("octopus")
        show_image:"img/26/octopus.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
               /* if(press != "0"){
                    return
                }
                press = "1"*/
                octopus.show_source = "img/26/down.png"
                coin.show_source = "img/button/1.png"
                app.show_source = "img/button/1.png"

                my_timer.stop()
                my_stack_view.push(on_develop_view)
            }
        }
    }
    //使用投币
    SelectServiceButton{
        id:coin
        x:402
        y:300
        show_text:qsTr("coin")
        show_image:"img/26/coin.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                octopus.show_source = "img/button/1.png"
                coin.show_source = "img/26/down.png"
                app.show_source = "img/button/1.png"

                my_timer.stop()
                my_stack_view.push(send_inser_coin_pagee,{designationSize:designationSize})
            }
        }
    }
    //使用手机支付
    SelectServiceButton{
        id:app
        x:644
        y:300
        show_text:qsTr("app")
        show_image:"img/26/app.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
             /*   if(press != "0"){
                    return
                }
                press = "1"*/
                octopus.show_source = "img/button/1.png"
                coin.show_source = "img/button/1.png"
                app.show_source = "img/26/down.png"

                my_timer.stop()
                my_stack_view.push(on_develop_view)
            }
        }
    }


    //返回菜单按钮
    OverTimeButton{
        id:back_button
        x:200
        y:600
        show_text:qsTr("back to menu")
        show_x:0
        show_image:"img/05/back.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 1) return true }))
            }
            onEntered:{
                back_button.show_source = "img/05/pushdown.png"
            }
            onExited:{
                back_button.show_source = "img/05/button.png"
            }
        }
    }
}
