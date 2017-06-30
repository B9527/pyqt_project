import QtQuick 2.4
import QtQuick.Controls 1.2

Background{

    property int timer_value: 60
    property var press:"0"

    //打开该页面时，初始化按键底色
    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            courier_take_package_button.show_source = "img/button/1.png"
            courier_take_overdue_button.show_source = "img/button/1.png"
            courier_take_it_button.show_source = "img/button/1.png"
            history_button.show_source = "img/button/1.png"
            other_services_button.show_source = "img/button/1.png"
            back_button.show_source = "img/button/7.png"
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
            slot_handler.courier_get_user()
            slot_handler.start_load_courier_overdue_express_count()
 //           slot_handler.start_load_customer_send_express_count()
            slot_handler.start_get_free_mouth_mun()
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

    //存儲包裹
    CourierServiceUpButton{
        id:courier_take_package_button
        x:390
        y:240
        show_text:qsTr("Stored packages")
        show_image:"img/courier10/StorageArticle.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                my_stack_view.push(courier_memory_view)
            }
            onEntered:{
                courier_take_package_button.show_source = "img/bottondown/down.png"
            }
            onExited:{
                courier_take_package_button.show_source = "img/button/1.png"
            }
        }
    }
    //取逾期件
    CourierServiceUpButton{
        id:courier_take_overdue_button
        x:580
        y:240
        show_text:qsTr("Take overdue packages")
        show_image:"img/courier10/overduearticle.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                my_stack_view.push(background_overdue_time_view)    //未实现，后续添加
            }
            onEntered:{
                courier_take_overdue_button.show_source = "img/bottondown/down.png"
            }
            onExited:{
                courier_take_overdue_button.show_source = "img/button/1.png"
            }
            Text {
                id: overdue_num
                x: 127
                y: 0
                color: "#ffffff"
                text: qsTr("10")
                anchors.right: parent.right
                anchors.rightMargin: 0
                styleColor: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                font.family:"Microsoft YaHei"
                font.bold: true
                font.pixelSize: 24
            }
        }
    }

    //取寄件
    CourierServiceUpButton{
        id:courier_take_it_button
        x:770
        y:240
        show_text:qsTr("Take it")
        show_image:"img/courier10/SendArticle.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                my_stack_view.push(on_develop_view)    //未实现，后续添加
                //my_stack_view.push(take_send_express_page)
            }
            onEntered:{
                courier_take_it_button.show_source = "img/bottondown/down.png"
            }
            onExited:{
                courier_take_it_button.show_source = "img/button/1.png"
            }
       /*     Text {
                id: send_num
                x: 141
                y: 0
                color: "#ffffff"
                text: qsTr("10")
                anchors.right: parent.right
                anchors.rightMargin: 0
                styleColor: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                font.family:"Microsoft YaHei"
                font.bold: true
                font.pixelSize: 24
            }*/
        }
    }
    //历史查询
    CourierServiceDownButton{
        id:history_button
        x:390
        y:450
        show_text:qsTr("History inquiry")
        show_image:"img/courier10/History.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                my_stack_view.push(on_develop_view)    //未实现，后续添加
            }
            onEntered:{
                history_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                history_button.show_source = "img/button/1.png"
            }
        }
    }
    //其他服务
    CourierServiceDownButton{
        id:other_services_button
        x:675
        y:450
        show_text:qsTr("Other services")
        show_image:"img/courier10/otherservices.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press = "1"
                my_stack_view.push(on_develop_view)   //未实现，后续添加
            }
            onEntered:{
                other_services_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                other_services_button.show_source = "img/button/1.png"
            }
        }
    }
    BackButton{
        id:back_button
        x:665
        y:630
        show_text:qsTr("return")

        MouseArea {
            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 1) return true }))
            }
            onEntered:{
                back_button.show_source = "img/bottondown/down.png"
            }
            onExited:{
                back_button.show_source = "img/button/7.png"
            }
        }
    }

    Column {
        x: 31
        y: 175
        spacing: 10

        Text{
            id:please_select_service
            text:qsTr("Please select\n service options")
            font.family:"Microsoft YaHei"
            color:"#444586"
            font.pixelSize:45
        }

        Image {
            id: image1
            width: 330
            height: 1
            source: "img/courier19/stripe.png"
        }

        Row {
            spacing: 12

            Column {
                spacing: 10

                Text {
                    id: mouth_title
                    text: qsTr("mouth")
                    font.family:"Microsoft YaHei"
                    color:"#444586"
                    font.pixelSize: 24
                }

                Text {
                    id: mini_type
                    text: qsTr("MINI")
                    font.family:"Microsoft YaHei"
                    color:"#444586"
                    font.pixelSize: 24
                }

                Text {
                    id: big_type
                    text: qsTr("BIG")
                    font.family:"Microsoft YaHei"
                    color:"#444586"
                    font.pixelSize: 24
                }

                Text {
                    id: mid_type
                    text: qsTr("MID")
                    font.family:"Microsoft YaHei"
                    color:"#444586"
                    font.pixelSize: 24
                }

                Text {
                    id: small_type
                    text: qsTr("SMALL")
                    font.family:"Microsoft YaHei"
                    color:"#444586"
                    font.pixelSize: 24
                }
            }

            Column {
                spacing: 10

                Text {
                    id: number_title1
                    text: qsTr("munber")
                    font.family:"Microsoft YaHei"
                    color:"#444586"
                    font.pixelSize: 24
                }

                Text {
                    id: mini_num
                    text: qsTr("0")
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignLeft
                    font.family:"Microsoft YaHei"
                    color:"#f67c00"
                    font.pixelSize: 24
                }

                Text {
                    width: 16
                    height: 31
                    id: big_num
                    text: qsTr("0")
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family:"Microsoft YaHei"
                    color:"#f67c00"
                    font.pixelSize: 24
                }

                Text {
                    id: mid_num
                    text: qsTr("0")
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family:"Microsoft YaHei"
                    color:"#f67c00"
                    font.pixelSize: 24
                }

                Text {
                    id: small_num
                    text: qsTr("0")
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family:"Microsoft YaHei"
                    color:"#f67c00"
                    font.pixelSize: 24
                }
            }
        }
    }




    Component.onCompleted: {
        root.overdue_express_count_result.connect(overdue_count)
        root.free_mouth_result.connect(show_free_mouth_num)
     //   root.send_express_count_result.connect(send_count)
    }

    Component.onDestruction: {
        root.overdue_express_count_result.disconnect(overdue_count)
        root.free_mouth_result.disconnect(show_free_mouth_num)
     //   root.send_express_count_result.disconnect(send_count)
    }
    //显示逾期件数量
    function overdue_count(text){
        overdue_num.text = text
    }
    //显示寄件数量
  /*  function send_count(text){
        send_num.text = text
    }*/
    //显示空闲格口数量
    function show_free_mouth_num(text){
        var obj = JSON.parse(text)
        for(var i in obj){
            if(i == "MINI"){
                mini_num.text = obj[i]
            }
            if(i == "L"){
                big_num.text = obj[i]
            }
            if(i == "M"){
                mid_num.text = obj[i]
            }
            if(i == "S"){
                small_num.text = obj[i]
            }
        }
    }

}
