import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    id: background1
    property int timer_value: 30
    property var press: "0"
    property var store_type:"store"
    property var memory:show_text
    //property var boxSize_status:text
    property var press_timer_button: 0
    property variant containerqml: null

    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
			slot_handler.start_get_mouth_status()

            //root.choose_mouth_result.connect(handle_mouth_open_status)
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
			//root.mouth_status_result.disconnect(handle_mouth_open_status)
        }
    }
	/*//是否成功打开阁口
    function handle_mouth_open_status(text){
        //console.log(text)
		if(text!="Success"){
			not_mouth.open()
			re_open_button.enabled = false
			back_menu_button.enabled = false
			ok_button.enabled = false
		}
    }

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
                   slot_handler.start_get_about_oainfo(memory)
                   my_stack_view.push(oa_init_page)
                }
            }
        }
        Timer{
        id:press_timer
        interval:3000
        repeat:true
        running:false
        triggeredOnStart:false
        onTriggered:{
            //console.log("press_timer_button : " + press_timer_button)
            press_timer_button = 0
            help_button.enabled = true
            press_timer.stop()
        }
    }
	}	
	//当前没有格口
    HideWindow{
        id:not_mouth
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("not_mouth")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:not_mouth_back
            x:350
            y:560
            show_text:qsTr("back")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    re_open_button.enabled = true
					back_menu_button.enabled = true
					ok_button.enabled = true
                    not_mouth.close()
                }
                onEntered:{
                    not_mouth_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    not_mouth_back.show_source = "img/button/7.png"
                }
            }
        }
    }
	

    //左右><按钮
    DoorLRButton{
        y:207
        x:70
        show_image:"img/door/l1.png"
    }
    DoorLRButton{
        y:207
        x:920
        show_image:"img/door/r1.png"
    }

    //箱子开门图片
    DoorEvey{
        y:247
        x:60
    }
    //该界面的操作按钮
    DoorButton{
        id:help_button
        y:620
        x:60
        show_text:qsTr("re-open")
        show_image:"img/door/1.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press_timer_button == 0){
                    //console.log(press_timer_button)
                    abc.counter = timer_value
                    my_timer.restart()
                    press_timer.start()
                    slot_handler.start_open_mouth_again()
                    press_timer_button = 1
                    help_button.enabled = false
                }
            }
            onEntered:{
                help_button.show_image = "img/door/down_1.png"
            }
            onExited:{
                help_button.show_image = "img/door/1.png"
            }
        }
    }

    DoorButton{
        id:back_menu_button
        y:620
        x:360
        show_text:qsTr("取消操作")
        show_image:"img/door/2.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                //slot_handler.start_store_customer_express()
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
            }
            onEntered:{
                back_menu_button.show_image = "img/door/down_2.png"
            }
            onExited:{
                back_menu_button.show_image = "img/door/2.png"
            }
        }
    }
    DoorButton{
        id:ok_button
        y:620
        x:660
        show_text:qsTr("挂载")
        show_image:"img/door/2.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                slot_handler.start_get_about_oainfo(memory)
                my_stack_view.push(oa_init_page)
            }
            onEntered:{
                ok_button.show_image = "img/door/down_2.png"
            }
            onExited:{
                ok_button.show_image = "img/door/2.png"
            }
        }
    }
    //提示打开箱门的信息
    Row {
        x: 93
        y: 165
        layoutDirection: Qt.LeftToRight

        Text {
            id: box_open_tips_1
            color: "#444586"
            text: qsTr("")
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
            id: box_open_tips_2
            color: "#444586"
            text: qsTr("号格口已经打开，请先插入硬盘，再点击挂载，谢谢！")
            font.family:"Microsoft YaHei"
            font.pixelSize: 30
        }
    }
    //超时的提示
    HideWindow{
        id:over_time_tips
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("操作超时，请返回主界面。")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:ok_back
            x:350
            y:560
            show_text:qsTr("back")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    press = "0"
                    abc.counter = timer_value
                    my_timer.restart()
                    over_time_tips.close()
                    re_open_button.enabled=true
                    back_menu_button.enabled=true
                    ok_button.enabled=true
                    my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
                }
                onEntered:{
                    ok_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    ok_back.show_source = "img/button/7.png"
                }
            }
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
        //console.log(t)
        mouth_number.text = t
    }
    function clickedfunc(temp){
        containerqml.clickedfunc(temp)
    }
}

