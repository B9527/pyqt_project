import QtQuick 2.4
import QtQuick.Controls 1.2

Background{


    id:true_input_phone
    property var show_text:""
    property int timer_value: 60
    property var press: "0"
    width: 1024
    height: 768

    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
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

        Text{
            id:countShow_test
            anchors.centerIn:parent
            color:"#32adb1"
            font.family:"Microsoft YaHei"
            font.pixelSize:40
        }


        Timer{
            id:my_timer
            interval:1000
            repeat:true
            running:true
            triggeredOnStart:true
            onTriggered:{
                countShow_test.text = abc.counter
                abc.counter -= 1
                if(abc.counter < 0){
                    my_timer.stop()
                    my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
                }
            }
        }
    }

    Rectangle{
        x: 0
        y: 0
        width: 1024
        height: 768
        color: "#472f2f"
        opacity: 0.4
    }

    Rectangle{

        x: 130
        y: 220
        width: 790
        height: 440

        Image {
            id: image1
            x: -5
            y: -2
            width: 800
            height: 450
            source: "img/courier13/layerground.png"

            Text {
                id: text1
                x: 0
                y: 40
                width: 800
                height: 60
                color: "#444586"
                font.family:"Microsoft YaHei"
                text: qsTr("Please check the customer mobile phone number")
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 30
                textFormat: Text.AutoText
            }

            Text {
                x: 0
                y: 140
                width: 800
                height: 60
                color: "#444586"
                text: qsTr("(customer verification code and QR CODE will be sent )")
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 17
                font.bold: true
                font.family:"Microsoft YaHei"
                textFormat: Text.AutoText
            }

            Text {
                y: 190
                width: 800
                height: 60
                color: "#444586"
                font.family:"Microsoft YaHei"
                text: show_text
                horizontalAlignment: Text.AlignHCenter
                font.pointSize:45
            }

        }

        //返回菜单按钮
        OverTimeButton{
            id:sure_back_button
            x:90
            y:300
            show_text:qsTr("back to menu")
            show_x:15
            show_image:"img/05/back.png"
            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    my_stack_view.push(courier_input_phone_view)
                }
                onEntered:{
                    sure_back_button.show_source = "img/05/pushdown.png"
                }
                onExited:{
                    sure_back_button.show_source = "img/05/button.png"
                }
            }
        }

        //确认，下一步按钮
        OverTimeButton{
            id:sure_ok_button
            x:430
            y:300
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
                    slot_handler.set_phone_number(show_text)
                    my_stack_view.push(courier_select_box_view)
                }
                onEntered:{
                    sure_ok_button.show_source = "img/05/pushdown.png"
                }
                onExited:{
                    sure_ok_button.show_source = "img/05/button.png"
                }
            }
        }

    }
}
