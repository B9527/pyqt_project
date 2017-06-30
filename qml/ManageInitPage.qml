import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    id: background1

    property var press:"0"
    property int timer_value: 300

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
            root.init_client_result.connect(handle_result)
            root.get_version_result.connect(handle_result_version)
            root.manager_get_box_info_result.connect(handle_result_box_info)
        }

        Component.onDestruction: {
            root.init_client_result.disconnect(handle_result)
            root.get_version_result.disconnect(handle_result_version)
            root.manager_get_box_info_result.disconnect(handle_result_box_info)
        }

        function handle_result_box_info(text){
            var obj = JSON.parse(text)
            show_operator.text = obj["operator_name"]
            show_locker_name.text = obj["name"]
            show_order_no.text = obj["order_no"]
            //    show_token.text = obj["token"]
            show_scanner_port.text = obj["scanner_port"]
            show_lock_machine_port.text = obj["lock_machine_port"]
            show_ups_port.text = obj["ups_port"]
        }

        function handle_result_version(text){
            show_version.text = text
        }

        function handle_result(text){
            press = "0"
            waiting.close()
            if(text == "Success"){
                main_page.enabled = false
                init_ok.open()
            }
            if(text == "ERROR"){
                main_page.enabled = false
                init_error.open()
            }
        }

        BackButton{
            x:26
            y:656
            show_text:qsTr("Back")

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(press != "0"){
                        return
                    }
                    press = "1"
                    my_stack_view.pop()
                }
            }
        }

        ManagerServiceButton{
            x:442
            y:651
            show_text:qsTr("Init")

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(press != "0"){
                        return
                    }
                    press = "1"
                    slot_handler.start_init_client()
                    main_page.enabled = false
                    waiting.open()
                }
            }
        }
    }

    Text {
        id: systeminfo
        x: 156
        y: 168
        color: "#444586"
        text: qsTr("System Info:")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.family:"Microsoft YaHei"
        font.pixelSize: 30
    }





    Text {
        id: configinfo
        x: 164
        y: 390
        color: "#444586"
        text: qsTr("Config Info:")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font.family:"Microsoft YaHei"
        font.pixelSize: 30
    }

    /*   Text {
        id: token
        x: 146
        y: 327
        text: qsTr("Token:")
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
        color: "#444586"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: show_token
        x: 229
        y: 327
        text: qsTr("show_token1")
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
        color: "#444586"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }*/


    Text {
        id: version
        x: 237
        y: 322
        text: qsTr("版本号:")
        anchors.right: show_version.left
        anchors.rightMargin: 10
        horizontalAlignment: Text.AlignRight
        font.family:"Microsoft YaHei"
        color:"#444586"
        font.pixelSize: 25
    }

    Text {
        id: show_version
        x: 336
        y: 322
        width: 56
        height: 34
        text: qsTr("Text")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.family:"Microsoft YaHei"
        color:"#444586"
        font.pixelSize: 25
    }


    Text {
        id: operator
        x: 223
        y: 213
        color: "#444586"
        text: qsTr("运营商:")
        anchors.right: show_operator.left
        anchors.rightMargin: 10
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
    }

    Text {
        id: show_operator
        x: 336
        y: 213
        color: "#444586"
        text: qsTr("show_operator")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
    }


    Text {
        id: locker_name
        x: 182
        y: 246
        color: "#444586"
        text: qsTr("柜名称:")
        anchors.right: show_locker_name.left
        anchors.rightMargin: 10
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
    }

    Text {
        id: show_locker_name
        x: 336
        y: 246
        color: "#444586"
        text: qsTr("show_locker_name")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
    }


    Text {
        id: order_no
        x: 214
        y: 284
        text: qsTr("智能快递柜号:")
        anchors.right: show_order_no.left
        anchors.rightMargin: 10
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
        color: "#444586"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: show_order_no
        x: 336
        y: 284
        text: qsTr("show_order_no")
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
        color: "#444586"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }


    Text {
        id: scanner_port
        x: 176
        y: 442
        text: qsTr("扫描枪端口:")
        anchors.right: show_scanner_port.left
        anchors.rightMargin: 10
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
        color: "#444586"
    }

    Text {
        id: show_scanner_port
        x: 336
        y: 442
        text: qsTr("show_scanner_port")
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
        color: "#444586"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }


    Text {
        id: lock_machine_port
        x: 109
        y: 480
        text: qsTr("锁控板端口:")
        anchors.right: show_lock_machine_port.left
        anchors.rightMargin: 10
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
        color: "#444586"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: show_lock_machine_port
        x: 336
        y: 480
        text: qsTr("show_lock_machine_port")
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
        color: "#444586"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }


    Text {
        id: ups_port
        x: 221
        y: 518
        text: qsTr("UPS Port:")
        anchors.right: show_ups_port.left
        anchors.rightMargin: 10
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
        color: "#444586"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: show_ups_port
        x: 336
        y: 518
        text: qsTr("show_ups_port")
        font.family:"Microsoft YaHei"
        font.pixelSize: 25
        color: "#444586"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }


    //等待系统操作提示
        HideWindow{
        id:waiting
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("请稍等.....")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
    }

    //初始化成功后弹出提示
      HideWindow{
        id:init_ok
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("Successful")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:init_ok_back
            x:350
            y:560
            show_text:qsTr("back")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    main_page.enabled = true
                    init_ok.close()
                }
                onEntered:{
                    init_ok_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    init_ok_back.show_source = "img/button/7.png"
                }
            }
        }
    }

    //初始化成功后弹出提示
      HideWindow{
        id:init_error
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("初始化失败")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:init_error_back
            x:350
            y:560
            show_text:qsTr("back")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    main_page.enabled = true
                    init_error.close()
                }
                onEntered:{
                    init_error_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    init_error_back.show_source = "img/button/7.png"
                }
            }
        }
    }
}
