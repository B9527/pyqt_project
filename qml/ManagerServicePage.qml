import QtQuick 2.4
import QtQuick.Controls 1.2

Background{


    property var name:""
    property var phone_number:""
    property var company_name: "Pakpobox"
    property int timer_value: 60

    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            abc.counter = timer_value
            my_timer.restart()
            slot_handler.start_load_manager_overdue_express_count()
        //    slot_handler.start_load_customer_send_express_count()
         //   slot_handler.start_load_customer_reject_express_count()
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

    Component.onCompleted: {
        root.user_info_result.connect(handle_result)
        root.overdue_express_count_result.connect(overdue_count)
    //    root.send_express_count_result.connect(send_count)
    //    root.reject_express_count_result.connect(reject_count)
        slot_handler.get_user_info()
    }

    Component.onDestruction: {
        root.user_info_result.disconnect(handle_result)
        root.overdue_express_count_result.disconnect(overdue_count)
    //    root.send_express_count_result.disconnect(send_count)
    //    root.reject_express_count_result.disconnect(reject_count)
    }

    function overdue_count(text){
        overdue_num.text = text
    }
/*
    //显示寄件数量
    function send_count(text){
        send_num.text = text
    }

    //显示退件数量
    function reject_count(text){
        reject_num.text = text
    }
*/
    function handle_result(text){
        var result = JSON.parse(text)
        name = result.name
        phone_number = result.phoneNumber
        company_name = result.company_name
    }

    //箱子开门图片
    //该界面的操作按钮

    Rectangle{
        Image {
            id: image1
            x: 64
            y: 603
            width: 910
            height: 1
            source: "img/courier19/stripe.png"
        }
    }
    //系统信息
    ManagerServiceButton{
        id:manager_service_button
        x: 106
        y: 396
        show_icon:"img/manage25/serviceinfo.png"
        show_text:qsTr("系统信息")
        MouseArea {
            anchors.rightMargin: -3
            anchors.bottomMargin: -2
            anchors.leftMargin: 3
            anchors.topMargin: 2
            anchors.fill: parent
            onClicked: {
                my_stack_view.push(box_manage_page)
            }
            onEntered:{
                manager_service_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                manager_service_button.show_source = "img/button/7.png"
            }
        }
    }

    //格口管理

    ManagerServiceButton{
        id:manager_service_button1
        x: 370
        y: 396
        show_icon:"img/manage25/doormanage.png"
        show_text:qsTr("box")
        MouseArea {
            anchors.rightMargin: -3
            anchors.bottomMargin: -1
            anchors.leftMargin: 3
            anchors.topMargin: 1
            anchors.fill: parent

            onClicked:{
                my_stack_view.push(manager_cabinet_view)
            }
            onEntered:{
                manager_service_button1.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                manager_service_button1.show_source = "img/button/7.png"
            }
        }
    }
    //取异常件
    ManagerServiceButton{
        id:manager_service_button2
        x: 644
        y: 497
        show_icon:"img/manage25/error.png"
        show_text:qsTr("取异常盘")
        MouseArea {
            anchors.rightMargin: -5
            anchors.bottomMargin: -4
            anchors.leftMargin: 5
            anchors.topMargin: 4
            anchors.fill: parent
            onClicked:{
                my_stack_view.push(on_develop_view)
                //my_stack_view.push(take_reject_express)
            }
            onEntered:{
                manager_service_button2.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                manager_service_button2.show_source = "img/button/7.png"
            }
       /*     Text {
                id: reject_num
                x: 183
                y: 0
                color: "#ffffff"
                text: qsTr("10")
                anchors.right: parent.right
                anchors.rightMargin: 8
                styleColor: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                font.family:"Microsoft YaHei"
                font.bold: true
                font.pixelSize: 24
            }*/
        }
    }

    //取逾期件
    ManagerServiceButton{
        id:manager_service_button3
        x: 644
        y: 396
        show_icon:"img/manage25/overduetime.png"
        show_text:qsTr("取逾期盘")
        MouseArea {
            anchors.rightMargin: -4
            anchors.bottomMargin: -2
            anchors.leftMargin: 4
            anchors.topMargin: 2
            anchors.fill: parent
            onClicked:{
                my_stack_view.push(manage_take_overdue_page)
            }
            onEntered:{
                manager_service_button3.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                manager_service_button3.show_source = "img/button/7.png"
            }
            Text {
                id: overdue_num
                x: 183
                y: 0
                color: "#ffffff"
                text: qsTr("10")
                anchors.right: parent.right
                anchors.rightMargin: 8
                styleColor: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                font.family:"Microsoft YaHei"
                font.bold: true
                font.pixelSize: 24
            }
        }
    }


    Image {
        id: image6
        x: 77
        y: 161
        width: 192
        height: 204
        source: "img/manage25/admin.png"
    }
    //地址
    Text {
        id: text1
        x: 299
        y: 315
        width: 100
        height: 50
        text: qsTr("address:")
        color:"#444586"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: "Verdana"
        font.pixelSize: 30
    }
    //电话号码
    Text {
        color:"#444586"
        id: text2
        x: 299
        y: 264
        width: 100
        height: 50
        text: qsTr("number:")
        font.family: "Verdana"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 30
    }
    //姓名
    Text {
        color:"#444586"
        id: text3
        x: 299
        y: 208
        width: 100
        height: 50
        text: qsTr("name:")
        verticalAlignment: Text.AlignVCenter
        font.family: "Verdana"
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 30
    }

    Text {
        color:"#444586"
        id: text4
        x: 424
        y: 315
        width: 428
        height: 50
        text: company_name
        font.family: "Verdana"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 30
    }

    Text {
        color:"#444586"
        id: text5
        x: 424
        y: 264
        width: 428
        height: 50
        text: phone_number
        verticalAlignment: Text.AlignVCenter
        font.family: "Verdana"
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 30
    }

    Text {
        color:"#444586"
        id: text6
        x: 424
        y: 208
        width: 428
        height: 50
        text: name
        font.family: "Verdana"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 30
    }
    //退出系统
    PickUpButton {
        id:pick_up_Button1
        x: 688
        y: 630
        show_text: qsTr("exit")

        MouseArea {
            anchors.leftMargin: 4
            anchors.bottomMargin: -2
            anchors.rightMargin: -4
            anchors.fill: parent
            anchors.topMargin: 2
            onClicked:{
                manager_take_send_express_button.enabled = false
                pick_up_Button2.enabled = false
                pick_up_Button1.enabled = false
                manager_service_button3.enabled = false
                manager_service_button2.enabled = false
                manager_service_button1.enabled = false
                manager_service_button.enabled = false
                check_quit.open()
            }
            onEntered:{
                pick_up_Button1.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                pick_up_Button1.show_source = "img/button/7.png"
            }
        }
    }
    //系统首页
    PickUpButton {
        id:pick_up_Button2
        x: 67
        y: 630
        show_text: qsTr("system idex")
        MouseArea {
            anchors.rightMargin: -4
            anchors.bottomMargin: -2
            anchors.leftMargin: 4
            anchors.topMargin: 2
            anchors.fill: parent
            onClicked:{
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
            }
            onEntered:{
                pick_up_Button2.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                pick_up_Button2.show_source = "img/button/7.png"
            }
        }

    }

    //取寄件
    ManagerServiceButton {
        id: manager_take_send_express_button
        x: 370
        y: 497
        show_text: qsTr("取挂盘")
        show_icon: "img/courier10/SendArticle.png"
        MouseArea {
            anchors.fill: parent
            onClicked:{
                my_stack_view.push(take_send_express_page)
            }
            onEntered:{
                manager_take_send_express_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                manager_take_send_express_button.show_source = "img/button/7.png"
            }
         /*   Text {
                id: send_num
                x: 183
                y: 0
                color: "#ffffff"
                text: qsTr("10")
                anchors.right: parent.right
                anchors.rightMargin: 8
                styleColor: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                font.family:"Microsoft YaHei"
                font.bold: true
                font.pixelSize: 24
            }*/
        }
    }

    //退出时的二次确认框
    HideWindow{
        id:check_quit
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("sure to quit")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //确定
        OverTimeButton{
            id:sure_button
            x:200
            y:560
            show_text:qsTr("sure")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    slot_handler.start_explorer()
                    Qt.quit()
                }
                onEntered:{
                    sure_button.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    sure_button.show_source = "img/button/7.png"
                }
            }
        }
        //取消
        OverTimeButton{
            id:back_button
            x:550
            y:560
            show_text:qsTr("back")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    manager_take_send_express_button.enabled = true
                    pick_up_Button2.enabled = true
                    pick_up_Button1.enabled = true
                    manager_service_button3.enabled = true
                    manager_service_button2.enabled = true
                    manager_service_button1.enabled = true
                    manager_service_button.enabled = true
                    check_quit.close()
                }
                onEntered:{
                    back_button.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    back_button.show_source = "img/button/7.png"
                }
            }
        }
    }


}
