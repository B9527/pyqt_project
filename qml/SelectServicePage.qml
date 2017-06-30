import QtQuick 2.1
import QtQuick.Controls 1.1

Background{

    property int timer_value: 60
    property var press:"0"
    //格口状态
    property var boxSize_status:""

    //打开该页面时，初始化按键底色
    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            take_button.show_source = "img/button/7.png"
            scan_button.show_source = "img/button/7.png"
            slot_handler.select_language("first.qm")
            //select_service_back_button.show_source = "img/button/7.png"
            press = "0"
            abc.counter = timer_value
            my_timer.restart()

            
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
            //root.mouth_status_result.disconnect(handle_mouth_status)
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

    //选择服务选项提示
    Text{
        id:please_select_service
        x:260
        y:208
        text:qsTr("欢迎使用，请选择服务:")
        horizontalAlignment: Text.AlignHCenter
        font.family:"Microsoft YaHei"
        color:"#444586"
        font.pixelSize:45
    }
    //跳转到管理员登陆界面
    SelectLoginButton{
        id:operator_login
        x:725
        y:70
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                my_timer.stop()
                my_stack_view.push(background_login_view,{"identity":"OPERATOR_USER"})

            }
        }
    }

    //取盘
    SelectServiceButton{
        id:take_button
        x:260
        y:300
        show_text:qsTr("取盘")
        show_image:"img/button/2.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                my_timer.stop()
                my_stack_view.push(customer_take_express_view)
            }
            onEntered:{
                take_button.show_source = "img/bottondown/down.png"
            }
            onExited:{
                take_button.show_source = "img/button/7.png"
            }
        }
    }

    //挂盘存件
    SelectServiceButton{
        id:scan_button
        x:553
        y:300
        show_text:qsTr("挂载硬盘 ")
        show_image:"img/button/14.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                my_timer.stop()
                my_stack_view.push(send_input_username_page)

            }
            onEntered:{
                scan_button.show_source = "img/bottondown/down.png"
            }
            onExited:{
                scan_button.show_source = "img/bottondown/down.png"
            }
        }
    }   
}
