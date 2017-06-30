import QtQuick 2.4
import QtQuick.Controls 1.2
/*
用户寄件时的用户协议页面 21
*/

Background{

    property int timer_value: 90
    property var press:"0"

    //打开该页面时，初始化按键底色
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

/**********************************************以下为功能**********************************************************/

    //协议边框
    Image {
        id: image1
        x: 58
        y: 235
        width:900
        height:350
        source: "img/21/back.png"

        Text {
            id: page1
            x: 5
            y: 5
            width: 890
            height: 340
            font.family:"Microsoft YaHei"
            color:"#444586"
            text: qsTr("test1")
            font.pixelSize: 17
            wrapMode:Text.Wrap
        }
        Text {
            id: page2
            x: 5
            y: 5
            visible: false
            width: 890
            height: 340
            font.family:"Microsoft YaHei"
            color:"#444586"
            text: qsTr("test2")
            font.pixelSize: 17
            wrapMode:Text.Wrap
        }
    }

    //取消并退出
    DoorButton{
        id:back_button
        y:620
        x:60
        show_text:qsTr("cencel")
        show_image:"img/door/2.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 1) return true }))
            }
            onEntered:{
                back_button.show_image = "img/door/down_2.png"
            }
            onExited:{
                back_button.show_image = "img/door/2.png"
            }
        }
    }
    //同意并确定
    DoorButton{
        id:ok_button
        y:620
        x:660
        show_text:qsTr("OK")
        show_image:"img/door/2.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                my_stack_view.push(send_input_memory_page)
            }
            onEntered:{
                ok_button.show_image = "img/door/down_2.png"
            }
            onExited:{
                ok_button.show_image = "img/door/2.png"
            }
        }
    }
    //请您阅读派宝箱用户协议
    Text {
        x: 269
        y: 182
        text: qsTr("please read ths user-agreement")
        font.family:"Microsoft YaHei"
        color:"#444586"
        font.pixelSize: 30
    }

    //上一页
    Rectangle{
        id:up_button
        x: 401
        y: 635
        width:40
        height:40
        color:"transparent"

        Image{
            width:40
            height:40
            source:"img/05/back_blue.png"
        }
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                abc.counter = timer_value
                my_timer.restart()
                if(page1.visible == true){
                    return
                }
                else{
                    text1.visible = true
                    text2.visible = false
                    page1.visible = true
                    page2.visible = false
                }
            }
        }
    }

    //下一页
    Rectangle{
        id:down_button
        x: 566
        y: 635
        width:40
        height:40
        color:"transparent"

        Image{
            width:40
            height:40
            source:"img/05/ok_blue.png"
        }
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                abc.counter = timer_value
                my_timer.restart()
                if(page2.visible == true){
                    return
                }
                else{
                    text1.visible = false
                    text2.visible = true
                    page1.visible = false
                    page2.visible = true
                }
            }
        }
    }

    Text {
        id: text1
        x: 471
        y: 635
        width: 0
        height: 0
        color: "#444586"
        text: qsTr("1/2")
        font.pixelSize: 40
    }

    Text {
        id: text2
        x: 471
        y: 635
        visible: false
        width: 0
        height: 0
        color: "#444586"
        text: qsTr("2/2")
        font.pixelSize: 40
    }

}
