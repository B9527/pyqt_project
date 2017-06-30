import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    id: background1
    property var press:"0"
    property int timer_value: 60

    //一进入当前页面的时候判断文本框的内容是否为空，不是为空就将其清空
    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            slot_handler.start_get_version()
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
            slot_handler.manager_get_box_info()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
        }
    }

    /*
    定时器
    时间到后自动跳转回上一页
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

Rectangle{
        id:main_page
        Component.onCompleted: {
            root.get_oainfo_result.connect(handle_result_oainfo)
        }
        Component.onDestruction: {

            root.get_oainfo_result.disconnect(handle_result_oainfo)
        }

        function handle_result_oainfo(text){
            console.log(text)
            if(text == "Success"){
                main_page.enabled = false
                //slot_handler.start_store_customer_express()
                slot_handler.start_store_express()
                store_success.open()
            }
            else{
                main_page.enabled = false
                slot_handler.start_open_mouth_again()
                store_false.open()
            }
        }
        Text{
        x:300
        y:350
        text:qsTr("挂盘验证中，请稍等.........")
        font.family:"Microsoft YaHei"
        width:280
        color:"#444586"
        font.pixelSize:45
        }

    }
    //失败系统操作提示
        HideWindow{
        id:store_false
        Text {
            id:store_false_message
            y:350
            width: 1024
            height: 60
            text: qsTr("挂盘失败，请重新操作！")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        OverTimeButton{
            id:try_again
            x:350
            y:560
            show_text:qsTr("重新操作！")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    main_page.enabled = true
                    store_false.close()
                    //my_stack_view.push(send_input_memory_page)
                    my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
                }
                onEntered:{
                    try_again.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    try_again.show_source = "img/button/7.png"
                }
            }
        }
        Component.onCompleted: {
            root.get_oainfo_result_message.connect(show_message)
        }
        Component.onDestruction: {
            root.get_oainfo_result_message.disconnect(show_message)
        }
        function show_message(message){
            console.log(message)
            store_false_message.text = message
        }
    }
    //成功系统操作提示
        HideWindow{
        id:store_success
        Text {
            id:store_success_message
            y:350
            width: 1024
            height: 60
            text: qsTr("挂盘成功！即将返回主页！")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        OverTimeButton{
            id:success_back
            x:350
            y:560
            show_text:qsTr("确认返回")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    main_page.enabled = true
                    store_success.close()
                    my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
                }
                onEntered:{
                    success_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    success_back.show_source = "img/button/7.png"
                }
            }
        }
        Component.onCompleted: {
            root.get_oainfo_result_message.connect(show_message)
        }
        Component.onDestruction: {
            root.get_oainfo_result_message.disconnect(show_message)
        }
        function show_message(message){
            console.log(message)
            store_success_message.text = message
        }
    }
}
