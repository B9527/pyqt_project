import QtQuick 2.4
import QtQuick.Controls 1.2

Background{

    property var press: "0"
    property int timer_value: 60
    property var door_num
    property var press_timer_button: 0

    //打开该页面时，初始化按键底色
    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            doorButton.show_image = "img/door/1.png"
            doorButton1.show_image = "img/door/2.png"
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
        }
    }

    //左右按钮
    DoorLRButton{
        y:415
        x:70
        show_image:"img/door/l1.png"
    }
    DoorLRButton{
        y:415
        x:920
        show_image:"img/door/r1.png"
    }

    //箱子开门图片
    DoorEvey{
        y:455
        x:60
    }
    //该界面的操作按钮
    //再次打开
    DoorButton{
        id:doorButton
        y:228
        x:670
        show_text:qsTr("Open again")
        show_image:"img/door/1.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press_timer_button == 0){
                    abc.counter = timer_value
                    my_timer.restart()
                    press_timer.start()
                    slot_handler.start_open_mouth_again()
                    press_timer_button = 1
                    doorButton.enabled = false
                }
            }
            onEntered:{
                doorButton.show_image = "img/bottondown/green_down.png"
            }
            onExited:{
                doorButton.show_image = "img/door/1.png"
            }
        }

        Image {
            id: image1
            x: 35
            y: 8
            source: "img/06/return.png"
        }
    }
    //确认
    DoorButton{
        id: doorButton1
        y:311
        x:670
        show_text:qsTr("卸载硬盘")
        show_image:"img/door/2.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                //my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index == 0) return true }))
                //slot_handler.customer_take_express_disks()
               slot_handler.customer_take_express_disks_check()
                my_stack_view.push(customer_take_express_disks_page)
            }
            onEntered:{
                doorButton1.show_image = "img/bottondown/down_1.png"
            }
            onExited:{
                doorButton1.show_image = "img/door/2.png"
            }
        }

        Image {
            id: image2
            x: 35
            y: 8
            source: "img/06/ok.png"
        }
    }

    Column {
        x: 60
        y: 225
        spacing: 5

        Row {
            spacing: 10

            Text {
                color: "#444586"
                text: qsTr("请于")
                font.family:"Microsoft YaHei"
                font.pixelSize: 30
            }

            Text {
                id:mouth_number
                color: "#32adb1"
                text: qsTr("X")
                font.family:"Microsoft YaHei"
                font.pixelSize: 30
            }

            Text {
                color: "#32adb1"
                text: qsTr("No.")
                font.family:"Microsoft YaHei"
                font.pixelSize: 30
            }

            Text {
                color: "#444586"
                text: qsTr("号格口，领取您的物件")
                font.family:"Microsoft YaHei"
                font.pixelSize: 30
            }
        }

        Text {
            color: "#444586"
            text: qsTr("(如果领取有问题, 请致电 39043668 查询)")
            font.family:"Microsoft YaHei"
            font.pixelSize: 24
        }
    }

    Column {
        x: 60
        y: 327
        spacing: 5

        Row {
            spacing: 10

            Text {
                color: "#444586"
                text: qsTr("系统将于")
                font.family:"Microsoft YaHei"
                font.pixelSize: 30
            }

            /*
定时器
30秒定时，时间到后自动跳转回菜单界面
*/
            Rectangle{
                width:39
                height:11
                y:10
                color:"transparent"
                QtObject{
                    id:abc
                    property int counter
                    Component.onCompleted:{
                        abc.counter = timer_value
                    }
                }

                Text{
                    id:countShow_test
                    x:183
                    y:500
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

            Timer{
                id:press_timer
                interval:6000
                repeat:true
                running:false
                triggeredOnStart:false
                onTriggered:{
                    //console.log("press_timer_button : " + press_timer_button)
                    press_timer_button = 0
                    press_timer.stop()
                    doorButton.enabled = true
                }
            }

            Text {
                color: "#32adb1"
                text: qsTr("秒后")
                font.family:"Microsoft YaHei"
                font.pixelSize: 30
            }

            Text {
                color: "#444586"
                text: qsTr("自动确认")
                font.family:"Microsoft YaHei"
                font.pixelSize: 30
            }
        }

        Text {
            width: 448
            height: 29
            color: "#444586"
            text: qsTr("取件后, 请关闭柜门, 多谢您使用本次服务！")
            font.family:"Microsoft YaHei"
            font.pixelSize: 24
        }
    }

    Component.onCompleted: {
        root.mouth_number_result.connect(show_text)
        slot_handler.get_express_mouth_number()
    }

    Component.onDestruction: {
        root.mouth_number_result.disconnect(show_text)
    }

    function show_text(t){
        mouth_number.text = t
        door_num = t
    }


}
