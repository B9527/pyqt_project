import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    /*
快递员取逾期件的界面，图片19
*/

    property int timer_value: 180
    property var press:"0"
    property var id
    property var phone_number
    property var phone_text
    property var phone
    property var send_time
    property var store_time
    property var number:8
    property var pay
    property var send_id
    property var remark
    property var save_time
    property var address
    property var time
    property var num
    property var check_list: new Array()
    property var page_num
    property var press_time:1
    property var show_express_id

    property var send_express_data
    property var send_express_num

    //已进入逾期件页面就加载逾期件
    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            slot_handler.start_customer_load_send_express_list(1)
            slot_handler.start_load_customer_send_express_count()

            up_button.visible = false
            up_button.enabled = false

            down_button.enabled = false
            down_button.visible = false

            press = "0"
            abc.counter = timer_value
            my_timer.restart()


        }

        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
        }
    }

    //计算逾期件的数量需要显示多少页，每页显示5条记录
    function count_page(send_express_num){
        if(send_express_num/5 > Math.floor(send_express_num/5)){
            page_num = Math.floor(send_express_num/5)+1
        }
        else
            page_num = send_express_num/5
    }

    focus:true

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


    PickUpButton{
        id:pick_up_Button
        y:620
        x:60
        show_text:qsTr("back")

        //按钮响应区域
        MouseArea {
            id:chk
            anchors.fill: parent
            onClicked: {
                my_stack_view.pop()
            }
            onEntered:{
                pick_up_Button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                pick_up_Button.show_source = "img/button/7.png"
            }
        }
    }
    //取回所选
    PickUpButton{
        id:pick_up_Button1
        y:620
        x:360
        show_text:qsTr("取回所选")

        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press="1"
                pick_up_Button.enabled = false
                pick_up_Button1.enabled = false
                pick_up_Button2.enabled = false
                page.enabled = false
                waiting_for_result.open()
                slot_handler.start_courier_take_send_express(JSON.stringify(check_list))
                slot_handler.start_customer_load_send_express_list(1)
                slot_handler.start_load_customer_send_express_count()
            }
            onEntered:{
                pick_up_Button1.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                pick_up_Button1.show_source = "img/button/7.png"
            }
        }
    }
    //全部取回
    PickUpButton{
        id:pick_up_Button2
        y:620
        x:660
        show_text:qsTr("take back all")

        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(press != "0"){
                    return
                }
                press="1"
                pick_up_Button.enabled = false
                pick_up_Button1.enabled = false
                pick_up_Button2.enabled = false
                page.enabled = false
                waiting_for_result.open()
                slot_handler.start_courier_take_send_express_all()
                slot_handler.start_customer_load_send_express_list(1)
                slot_handler.start_load_customer_send_express_count()
            }
            onEntered:{
                pick_up_Button2.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                pick_up_Button2.show_source = "img/button/7.png"
            }
        }
    }

    Rectangle{
        Image {
            id: image1
            x: 60
            y: 161
            width: 880
            height: 45
            source: "img/courier19/one.png"
        }
        Row {
            id: row1
            x: 60
            y: 150
            width: 880
            height: 69

            //寄件单号
            Rectangle{
                Text{
                    font.family:"Microsoft YaHei"
                    text:qsTr("挂盘单号")
                    anchors.verticalCenterOffset: 35
                    anchors.horizontalCenterOffset: 80
                    color:"white"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }
            }

            //寄件时间
            Rectangle{
                Text{

                    font.family:"Microsoft YaHei"
                    text:qsTr("store-time")
                    anchors.verticalCenterOffset: 35
                    anchors.horizontalCenterOffset:400
                    color:"white"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }
            }

            //格口
            Rectangle{
                Text{

                    font.family:"Microsoft YaHei"
                    text:qsTr("box")
                    anchors.verticalCenterOffset: 35
                    anchors.horizontalCenterOffset: 800
                    color:"white"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }
            }

            //已付郵資
            /*      Rectangle{
                Text{

                    font.family:"Microsoft YaHei"
                    text:qsTr("cost")
                    anchors.verticalCenterOffset: 35
                    anchors.horizontalCenterOffset: 810
                    color:"white"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }
            }*/
        }
    }


    // 页面
    Item  {
        id: page
        x:60
        y:220
        width: 870
        height:300

        ListView{
            id:listView
            anchors.fill:parent
            model:model
            delegate:listDel
            snapMode:ListView.SnapOneItem
        }

        // 模型
        ListModel {
            id: model
        }

        // 视图
        ListView {
            id: view
            anchors.fill: parent
            model: model
            delegate: delegate
            spacing:0
            interactive:false
        }

        // 代理
        Component {
            id: listDel
            // 列表项
            Rectangle {
                height: 60

                //每条数据的分割线
                Image {
                    id: image1
                    y:60
                    width: 880
                    height: 1
                    source: "img/courier19/stripe.png"
                }

                //每条数据对应的复选框
                CheckBox {
                    id: checkbox1
                    x:20
                    width:60
                    height:60

                    onCheckedChanged: {
                        abc.counter = timer_value
                        my_timer.restart()
                        if (checked) {
                            check_list.push(show_express_id)
                        } else {
                            for(var i in check_list){
                                if(show_express_id == check_list[i]){
                                    check_list.splice(i,1)
                                }
                            }
                        }
                    }
                }

                //寄件单号
                Text{
                    font.family:"Microsoft YaHei"
                    text:username
                    anchors.horizontalCenterOffset: 80
                    color:"#444586"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }

                //寄件时间

                Text{
                    font.family:"Microsoft YaHei"
                    text:save_time
                    anchors.horizontalCenterOffset: 400
                    color:"#444586"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }

                //格口
                Text{
                    font.family:"Microsoft YaHei"
                    text:number
                    anchors.horizontalCenterOffset: 800
                    color:"#444586"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }

                /*      //已付郵資
                Text{
                    font.family:"Microsoft YaHei"
                    text:cost
                    anchors.horizontalCenterOffset: 810
                    color:"#444586"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }*/

                Text{
                    font.family:"Microsoft YaHei"
                    text:show_express_id
                    visible:false
                    anchors.horizontalCenterOffset: 810
                    color:"#444586"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }
            }
        }
    }

    //解析逾期件的数据，并显示在页面上
    function show_send_express(send_express_data){
        if(send_express_data==""){
            return
        }
        var obj = JSON.parse(send_express_data)
        for(var i in obj){

            //寄件单号
            send_id = obj[i].customerStoreNumber

            //获得存件时间
            time = obj[i].storeTime
            var time_Y = add_zero(date.getFullYear());
            var time_M = add_zero((date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1));
            var time_D = add_zero(date.getDate());
            var time_h = add_zero(date.getHours());
            var time_m = add_zero(date.getMinutes());
            var time_s = add_zero(date.getSeconds());
            store_time = time_Y+"-"+time_M+"-"+time_D+" "+time_h+":"+time_m+":"+time_s

            //获得格口号
            num = obj[i].mouth.number

            //已付邮资
            /*   for(var j in obj[i].amount){
                pay = obj[i][j].amount
                    pay = (0-pay)/100
            }*/

            //快件id
            id = obj[i].id

            model.append({"username":send_id,"save_time": store_time,"number": num/*,"cost": pay*/,"show_express_id":id});
        }
    }
    function add_zero(temp)
    {
        if(temp<10) return "0"+temp;
        else return temp;
    }

    //上一页
    Rectangle{
        id:up_button
        y:540
        x:60
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
                //清空数据，包括上页所选择的逾期件
                model.clear()
                check_list = new Array()
                send_express_data = ""
                down_button.visible = true
                down_button.enabled = true
                press_time = press_time-1
                slot_handler.start_customer_load_send_express_list(press_time)
                if(press_time == 1){
                    up_button.visible = false
                    up_button.enabled = false
                }
            }
        }
    }

    //下一页
    Rectangle{
        id:down_button
        y:540
        x:660
        width:40
        height:40
        color:"transparent"
        anchors.right: parent.right
        anchors.rightMargin: 80

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
                //清空数据，包括上页所选择的逾期件
                model.clear()
                check_list = new Array()
                send_express_data = ""
                up_button.visible = true
                up_button.enabled = true
                press_time = press_time+1
                slot_handler.start_customer_load_send_express_list(press_time)
                if(press_time == page_num){
                    down_button.visible = false
                    down_button.enabled = false
                }
            }
        }
    }

    //等待结果界面
    HideWindow{
        id:waiting_for_result
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("请稍等")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
    }

    //未选择逾期件时的提示
    HideWindow{
        id:set_null
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("无可取盘")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:set_null_back
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
                    model.clear()
                    pick_up_Button.enabled = true
                    pick_up_Button1.enabled = true
                    pick_up_Button2.enabled = true
                    page.enabled = true
                    slot_handler.start_customer_load_send_express_list(1)
                    set_null.close()
                }
                onEntered:{
                    set_null_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    set_null_back.show_source = "img/button/7.png"
                }
            }
        }
    }

    //取逾期件成功提示
    HideWindow{
        id:set_ok
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
            id:set_ok_back
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
                    model.clear()
                    pick_up_Button.enabled = true
                    pick_up_Button1.enabled = true
                    pick_up_Button2.enabled = true
                    page.enabled = true
                    slot_handler.start_customer_load_send_express_list(1)
                    set_ok.close()
                }
                onEntered:{
                    set_ok_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    set_ok_back.show_source = "img/button/7.png"
                }
            }
        }
    }

    //取逾期件失败提示
    HideWindow{
        id:set_failed
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("取盘失败，请联系工作人员")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:set_failed_back
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
                    model.clear()
                    pick_up_Button.enabled = true
                    pick_up_Button1.enabled = true
                    pick_up_Button2.enabled = true
                    page.enabled = true
                    slot_handler.start_customer_load_send_express_list(1)
                    set_failed.close()
                }
                onEntered:{
                    set_failed_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    set_failed_back.show_source = "img/button/7.png"
                }
            }
        }
    }

    Component.onCompleted: {
        root.send_express_list_result.connect(send_express_list)
        root.send_express_count_result.connect(send_count)
        root.take_send_express_result.connect(take_result)
    }

    Component.onDestruction: {
        root.send_express_list_result.disconnect(send_express_list)
        root.send_express_count_result.disconnect(send_count)
        root.take_send_express_result.disconnect(take_result)
    }

    function take_result(text){
        waiting_for_result.close()
        if(text == 'Success'){
            check_list = new Array()
            set_ok.open()
        }
        else if(text == 'None'){
            check_list = new Array()
            set_null.open()
        }
        else{
            check_list = new Array()
            set_failed.open()
        }
    }

    function send_express_list(text){
        send_express_data = text
        show_send_express(text)
    }

    function send_count(text){
        send_express_num = text
        count_page(text)
        if(text<=5){
            down_button.enabled = false
            down_button.visible = false
        }
        else{
            down_button.enabled = true
            down_button.visible = true
        }
    }
}
