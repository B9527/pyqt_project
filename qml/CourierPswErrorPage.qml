import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    property int timer_value: 60
    width: 1024
    height: 768

    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
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


    //选择服务选项提示
    Text{
        id:please_select_service
        x:0
        y:220
        width: 1024
        height: 60
        text:qsTr("the account number or password is not correct")
        font.family:"Microsoft YaHei"
        horizontalAlignment: Text.AlignHCenter
        color:"#444586"
        font.pixelSize:45
    }

    BackButton{
        id:psw_error_button
        x:365
        y:550
        show_text:qsTr("return")

        MouseArea {

            anchors.fill: parent
            onClicked: {
                my_stack_view.pop()
            }
            onEntered:{
                psw_error_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                psw_error_button.show_source = "img/button/7.png"
            }
        }
    }

    Text {
        id: text1
        x: 0
        y: 390
        width: 1024
        height: 60
        color:"#444586"
        font.family:"Microsoft YaHei"
        text: qsTr("Please re - enter your account name and password, thank you!")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 27
    }
}
