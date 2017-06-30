import QtQuick 2.4
import QtQuick.Controls 1.2
/*
boxSize_status:当前尺寸的箱子是否可用，T为可用，F为不可用
*/
Background{
    id:customer_select_box

    property var boxSize_status:"FFFF"
    property int timer_value: 60
    property var press: "0"
    property var store_type: "store"

    //页面启动时，根据可用格口状�?�，显示该大小的格口是否可以被�?�择使用
    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            updateStatus()
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停�?
            my_timer.stop()
        }
    }

    function updateStatus(){
        if( boxSize_status.substring(0,1) == "T"){ //当所有大小格口有空闲时，显示正常背景�?
            mini_box.show_source = "img/courier14/14ground.png"
            mini_box.enabled = true
        }
        else{//无可用格口时，背景设置为灰色，同时不可点�?
            mini_box.show_source = "img/courier14/gray.png"
            mini_box.enabled = false
        }

        if( boxSize_status.substring(1,2) == "T"){ //当所有大小格口有空闲时，显示正常背景�?
            big_box.show_source = "img/courier14/14ground.png"
            big_box.enabled = true
        }
        else{//无可用格口时，背景设置为灰色，同时不可点�?
            big_box.show_source = "img/courier14/gray.png"
            big_box.enabled = false
        }

        if( boxSize_status.substring(2,3) == "T"){ //当所有大小格口有空闲时，显示正常背景�?
            middle_box.show_source = "img/courier14/14ground.png"
            middle_box.enabled = true
        }

        else{//无可用格口时，背景设置为灰色，同时不可点�?
            middle_box.show_source = "img/courier14/gray.png"
            middle_box.enabled = false
        }

        if( boxSize_status.substring(3,4) == "T"){ //当所有大小格口有空闲时，显示正常背景�?
            small_box.show_source = "img/courier14/14ground.png"
            small_box.enabled = true
        }
        else{//无可用格口时，背景设置为灰色，同时不可点�?
            small_box.show_source = "img/courier14/gray.png"
            small_box.enabled = false
        }
    }

    /*
    定时�?
    30秒定时，时间到后自动跳转回菜单界�?
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
                    if(store_type == "store"){
                        my_timer.stop()
                        my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
                    }
                    if(store_type == "change"){
                        my_timer.stop()
                        slot_handler.start_store_express()
                        my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
                    }
                }
            }
        }
    }

    //选择箱子尺寸的提�?
    Text{
        id:please_select_service
        x:200
        y:240
        text:qsTr("please select service option")
        color:"#444586"
        font.family:"Microsoft YaHei"
        font.pixelSize:30
    }

    Row {
        x: 200
        y: 320
        spacing: 20
        //迷你
        CourierSelectBoxSizeButton{
            id:mini_box
            show_text:qsTr("Mini")
            show_image:"img/courier14/yuan.png"
            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(press != "0"){
                        return
                    }
                    press = "1"
                    mini_box.show_source = "img/courier14/down.png"
                    slot_handler.start_choose_mouth_size("MINI","customer_store_express")
                }

                Text {
                    id: mini_num
                    x: 123
                    y: 0
                    color: "#ffffff"
                    text: qsTr("0")
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

        //�?
        CourierSelectBoxSizeButton{
            id:big_box
            show_text:qsTr("Big")
            show_image:"img/courier14/yuan.png"
            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(press != "0"){
                        return
                    }
                    press = "1"
                    big_box.show_source = "img/courier14/down.png"
                    slot_handler.start_choose_mouth_size("L","customer_store_express")
                }

                Text {
                    id: big_num
                    x: 127
                    y: 0
                    color: "#ffffff"
                    text: qsTr("0")
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

        //�?
        CourierSelectBoxSizeButton{
            id:middle_box
            show_text:qsTr("Mid")
            show_image:"img/courier14/yuan.png"
            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(press != "0"){
                        return
                    }
                    press = "1"
                    middle_box.show_source = "img/courier14/down.png"
                    slot_handler.start_choose_mouth_size("M","customer_store_express")
                }

                Text {
                    id: mid_num
                    x: 126
                    y: 0
                    color: "#ffffff"
                    text: qsTr("0")
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

        //�?
        CourierSelectBoxSizeButton{
            id:small_box
            show_text:qsTr("Small")
            show_image:"img/courier14/yuan.png"
            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(press != "0"){
                        return
                    }
                    press = "1"
                    small_box.show_source = "img/courier14/down.png"
                    slot_handler.start_choose_mouth_size("S","customer_store_express")
                }

                Text {
                    id: small_num
                    x: 127
                    y: 0
                    color: "#ffffff"
                    text: qsTr("0")
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
    }

    //返回菜单按钮
    OverTimeButton{
        id:select_box_back_button
        x:350
        y:600
        show_text:qsTr("back to menu")
        show_x:15
        show_image:"img/05/back.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 2) return true }))
            }
            onEntered:{
                select_box_back_button.show_source = "img/05/pushdown.png"
            }
            onExited:{
                select_box_back_button.show_source = "img/05/button.png"
            }
        }
    }

    Component.onCompleted: {
        root.choose_mouth_result.connect(handle_text)
        root.mouth_status_result.connect(handle_mouth_status)
        root.free_mouth_result.connect(show_free_mouth_num)
        slot_handler.start_get_mouth_status()
        slot_handler.start_get_free_mouth_mun()
    }

    Component.onDestruction: {
        root.choose_mouth_result.disconnect(handle_text)
        root.mouth_status_result.disconnect(handle_mouth_status)
        root.free_mouth_result.disconnect(show_free_mouth_num)
    }

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

    function handle_text(text){
        if(text == 'Success'){
            my_stack_view.push(reject_Door_open_page,{store_type:"store",containerqml:customer_select_box});
        }
    }

    function handle_mouth_status(text){
        boxSize_status = text
        updateStatus()
    }

    function clickedfunc(temp){
            store_type = temp
        }

}
