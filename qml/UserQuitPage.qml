import QtQuick 2.4
import QtQuick.Controls 1.2


Background{
    property int timer_value: 60
    property var press : "0"
    
    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
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

    Text {
        id: text1
        x: 80
        y: 220
        width: 400
        height: 40
        text: qsTr("please choice")
        font.family:"Microsoft YaHei"
        color:"#444586"
        wrapMode: Text.NoWrap
        font.pixelSize: 45
    }

    //不是我的包裹
    UserQuitButton{
        id:user_quit_button
        x: 80
        y: 290
        show_text:"Not my package"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {

            }
            onEntered:{
                user_quit_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                user_quit_button.show_source = "img/button/7.png"
            }
        }
    }
    //包裹破损
    UserQuitButton{
        id:user_quit_button1
        x: 370
        y: 290
        show_text:"bad"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {

            }
            onEntered:{
                user_quit_button1.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                user_quit_button1.show_source = "img/button/7.png"
            }
        }
    }
    //货品破损
    UserQuitButton{
        id:user_quit_button2
        x: 658
        y: 290
        show_text:"bad2"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {

            }
            onEntered:{
                user_quit_button2.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                user_quit_button2.show_source = "img/button/7.png"
            }
        }
    }
    //数目不符
    UserQuitButton{
        id:user_quit_button3
        x: 210
        y: 435
        show_text:"num not right"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {

            }
            onEntered:{
                user_quit_button3.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                user_quit_button3.show_source = "img/button/7.png"
            }
        }
    }
    //其他原因
    UserQuitButton{
        id:user_quit_button4
        x:498
        y:435
        show_text:"other"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {

            }
            onEntered:{
                user_quit_button4.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                user_quit_button4.show_source = "img/button/7.png"
            }
        }
    }


    //返回菜单按钮
    OverTimeButton{
        id:user_quit_button5
        x:192
        y:630
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
                user_quit_button5.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                user_quit_button5.show_source = "img/button/7.png"
            }
        }
    }
    //确认，下一步按钮
    OverTimeButton{
        id:user_quit_button6
        x:524
        y:628
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
                my_stack_view.push(door_open_view)
            }
            onEntered:{
                user_quit_button6.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                user_quit_button6.show_source = "img/button/7.png"
            }
        }
    }




}
