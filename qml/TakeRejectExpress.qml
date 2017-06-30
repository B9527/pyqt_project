import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    /*
���Աȡ���ڼ��Ľ��棬ͼƬ19
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

    //�ѽ������ڼ�ҳ��ͼ������ڼ�
    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){

            slot_handler.start_customer_load_reject_express_list(1)
            slot_handler.start_load_customer_reject_express_count()

            up_button.visible = false
            up_button.enabled = false

            down_button.enabled = false
            down_button.visible = false

            press = "0"
            abc.counter = timer_value
            my_timer.restart()


        }

        if(Stack.status==Stack.Deactivating){//���ڵ�ǰҳ��ʱ����ʱ��ֹͣ
            my_timer.stop()
        }
    }

    //�������ڼ���������Ҫ��ʾ����ҳ��ÿҳ��ʾ5����¼
    function count_page(send_express_num){
        if(send_express_num/5 > Math.floor(send_express_num/5)){
            page_num = Math.floor(send_express_num/5)+1
        }
        else
            page_num = send_express_num/5
    }

    focus:true

    /*
    ��ʱ��
    30�붨ʱ��ʱ�䵽���Զ���ת�ز˵�����
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

        //��ť��Ӧ����
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
    //ȡ����ѡ
    PickUpButton{
        id:pick_up_Button1
        y:620
        x:360
        show_text:qsTr("take back it")

        //��ť��Ӧ����
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
                slot_handler.start_courier_take_reject_express(JSON.stringify(check_list))
                slot_handler.start_customer_load_reject_express_list(1)
                slot_handler.start_load_customer_reject_express_count()
            }
            onEntered:{
                pick_up_Button1.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                pick_up_Button1.show_source = "img/button/7.png"
            }
        }
    }
    //ȫ��ȡ��
    PickUpButton{
        id:pick_up_Button2
        y:620
        x:660
        show_text:qsTr("take back all")

        //��ť��Ӧ����
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
                slot_handler.start_courier_take_reject_express_all()
                slot_handler.start_customer_load_reject_express_list(1)
                slot_handler.start_load_customer_reject_express_count()
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

            //�ļ�����
            Rectangle{
                Text{
                    font.family:"Microsoft YaHei"
                    text:qsTr("id")
                    anchors.verticalCenterOffset: 35
                    anchors.horizontalCenterOffset: 80
                    color:"white"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }
            }

            //�ļ�ʱ��
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

            //���
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
        }
    }


    // ҳ��
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

        // ģ��
        ListModel {
            id: model
        }

        // ��ͼ
        ListView {
            id: view
            anchors.fill: parent
            model: model
            delegate: delegate
            spacing:0
            interactive:false
        }

        // ����
        Component {
            id: listDel
            // �б���
            Rectangle {
                height: 60

                //ÿ�����ݵķָ���
                Image {
                    id: image1
                    y:60
                    width: 880
                    height: 1
                    source: "img/courier19/stripe.png"
                }

                //ÿ�����ݶ�Ӧ�ĸ�ѡ��
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

                //�ļ�����
                Text{
                    font.family:"Microsoft YaHei"
                    text:username
                    anchors.horizontalCenterOffset: 80
                    color:"#444586"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }

                //�ļ�ʱ��

                Text{
                    font.family:"Microsoft YaHei"
                    text:save_time
                    anchors.horizontalCenterOffset: 400
                    color:"#444586"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }

                //���
                Text{
                    font.family:"Microsoft YaHei"
                    text:number
                    anchors.horizontalCenterOffset: 800
                    color:"#444586"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }

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

    //�������ڼ������ݣ�����ʾ��ҳ����
    function show_send_express(send_express_data){
        if(send_express_data==""){
            return
        }
        var obj = JSON.parse(send_express_data)
        for(var i in obj){

            //�ļ�����
            send_id = obj[i].customerStoreNumber

            //��ô��ʱ��
            time = obj[i].storeTime
            var date = new Date(time);
            var time_Y = add_zero(date.getFullYear());
            var time_M = add_zero((date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1));
            var time_D = add_zero(date.getDate());
            var time_h = add_zero(date.getHours());
            var time_m = add_zero(date.getMinutes());
            var time_s = add_zero(date.getSeconds());
            store_time = time_Y+"-"+time_M+"-"+time_D+" "+time_h+":"+time_m+":"+time_s

            //��ø�ں�
            num = obj[i].mouth.number

            //���id
            id = obj[i].id

            model.append({"username":send_id,"save_time": store_time,"number": num,"show_express_id":id});
        }
    }

    function add_zero(temp){
         if(temp<10) return "0"+temp;
         else return temp;
    }

    //��һҳ
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
        //��ť��Ӧ����
        MouseArea {
            anchors.fill: parent
            onClicked: {
                abc.counter = timer_value
                my_timer.restart()
                //������ݣ�������ҳ��ѡ������ڼ�
                model.clear()
                check_list = new Array()
                send_express_data = ""
                down_button.visible = true
                down_button.enabled = true
                press_time = press_time-1
                slot_handler.start_customer_load_reject_express_list(press_time)
                if(press_time == 1){
                    up_button.visible = false
                    up_button.enabled = false
                }
            }
        }
    }

    //��һҳ
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
        //��ť��Ӧ����
        MouseArea {
            anchors.fill: parent
            onClicked: {
                abc.counter = timer_value
                my_timer.restart()
                //������ݣ�������ҳ��ѡ������ڼ�
                model.clear()
                check_list = new Array()
                send_express_data = ""
                up_button.visible = true
                up_button.enabled = true
                press_time = press_time+1
                slot_handler.start_customer_load_reject_express_list(press_time)
                if(press_time == page_num){
                    down_button.visible = false
                    down_button.enabled = false
                }
            }
        }
    }

    //�ȴ��������
    HideWindow{
        id:waiting_for_result
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("waiting")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
    }

    //δѡ�����ڼ�ʱ����ʾ
    HideWindow{
        id:set_null
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("set_null")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //����
        OverTimeButton{
            id:set_null_back
            x:350
            y:560
            show_text:qsTr("back")
            show_x:15

            //��ť��Ӧ����
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
                    slot_handler.start_customer_load_reject_express_list(1)
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

    //ȡ���ڼ��ɹ���ʾ
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
        //����
        OverTimeButton{
            id:set_ok_back
            x:350
            y:560
            show_text:qsTr("back")
            show_x:15

            //��ť��Ӧ����
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
                    slot_handler.start_customer_load_reject_express_list(1)
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

    //ȡ���ڼ�ʧ����ʾ
    HideWindow{
        id:set_failed
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("Failed")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //����
        OverTimeButton{
            id:set_failed_back
            x:350
            y:560
            show_text:qsTr("back")
            show_x:15

            //��ť��Ӧ����
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
                    slot_handler.start_customer_load_reject_express_list(1)
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
        root.reject_express_list_result.connect(send_express_list)
        root.reject_express_count_result.connect(send_count)
        root.take_reject_express_result.connect(take_result)
    }

    Component.onDestruction: {
        root.reject_express_list_result.disconnect(send_express_list)
        root.reject_express_count_result.disconnect(send_count)
        root.take_reject_express_result.disconnect(take_result)
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
