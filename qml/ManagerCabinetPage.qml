import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3


Background{
    /*22*/
    property var show_box_number:""
    property var show_size:""
    property var show_image_status:"img/manage22/fulllocker.png"
    property var show_image_size:"img/manage22/c.png"
    property int timer_value: 420
    property var press : "0"
    property var press_time:1

    property var box_id
    property var box_size
    property var box_status
    property var box_number

    property var show_box_number_temp
    property var show_size_temp
    property var show_image_status_temp
    property var show_image_size_temp
    property var show_box_status
    property var box_id_list

    property var set_box_window_show_id:""
    property var set_box_window_show_last_store_time:""
    property var set_box_window_show_boxsize:""
    property var set_box_window_show_boxnum:""
    property var set_box_window_show_box_status:""
    property var set_box_window_show_box_id: ""

    property var setbox_status

    property var cabinet_data
    property var cabinet_num: 25

    property var page_num
    property var set_status_time:1
    property int size:10 // 控制显示的字体和选项高度的

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

    //一进入格口管理页面就加格口信息
    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            page.enabled = false
            pick_up_Button2.enabled = false
            pick_up_Button1.enabled = false
            up_button.enabled = false
            down_button.enabled = false
            waiting.open()
            slot_handler.start_load_mouth_list(1)
            slot_handler.start_load_manager_mouth_count()

            down_button.enabled = false
            down_button.visible = false
            up_button.visible = false
            up_button.enabled = false
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
        }
    }


    // 页面
    Item  {
        id: page
        x:66
        y:280
        width:750
        height:300

        GridView{
            id:gridview
            anchors.fill: parent
            delegate: griddel
            model:gridModel
            cellWidth: 180
            cellHeight: 60
            flow:Grid.TopToBottom
            interactive: false
            contentY: listview.contentY

        }

        // 视图
        ListView {
            id: listview
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            model: listModel
            delegate: delegate
            spacing:0
            interactive:false
        }

        // 代理
        Component {
            id: griddel

            // 列表项
            Rectangle {
                color: "transparent"
                Text{
                    font.family:"Microsoft YaHei"
                    text:show_box_id
                    visible:false
                    anchors.horizontalCenterOffset: 810
                    color:"#444586"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }
                Text{
                    id:text_show_box_status
                    font.family:"Microsoft YaHei"
                    text:show_box_status
                    visible:false
                    anchors.horizontalCenterOffset: 810
                    color:"#444586"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }
                Text{
                    id:text_show_box_size
                    font.family:"Microsoft YaHei"
                    text:show_box_size
                    visible:false
                    anchors.horizontalCenterOffset: 810
                    color:"#444586"
                    font.pixelSize:17
                    anchors.centerIn: parent;
                }
                //格口状态
                Image {
                    id: image1
                    x: 0
                    y: 0
                    width: 150
                    height: 50
                    source: show_image_status

                    Text {
                        id: text1
                        x: 0
                        y: 0
                        width: 110
                        height: 50
                        text:show_box_number
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 12
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            abc.counter = timer_value
                            my_timer.restart()
                            set_box_window_show_id=show_box_number
                       //     set_box_window_show_last_store_time = "2015-05-01"
                            set_box_window_show_boxsize=text_show_box_size.text
                            set_box_window_show_boxnum = show_box_number
                            set_box_window_show_box_status = text_show_box_status.text
                            set_box_window_show_box_id = show_box_id
                            setbox_status = show_box_status
                            box_id_list = show_box_id
                            page.enabled = false
                            pick_up_Button2.enabled = false
                            pick_up_Button1.enabled = false
                            up_button.enabled = false
                            down_button.enabled = false
                            set_box_window.open()
                        }
                    }
                }
                //格口大小
                Image {
                    id: image2
                    x: 100
                    y: 0
                    width: 50
                    height: 50
                    source: show_image_size

                    Text {
                        id: text2
                        x: 0
                        y: 0
                        width: 50
                        height: 50
                        text:show_size
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 12
                    }
                }
            }


        }
        // 模型
        ListModel {
            id: gridModel
        }

        Component{
            id:delegate
            Rectangle{
                width: 150
                height: 70
                color: "transparent"
            }
        }

        ListModel{
            id:listModel
        }
    }

    //状态提示
    Image {

        x: 466
        y: 203
        width: 500
        height: 50
        source: "img/manage22/statusmap.png"
    }

    Text {

        x: 76
        y: 200
        width: 300
        height: 50
        text: qsTr("箱体设定")
        font.family:"Microsoft YaHei"
        color:"#444586"
        textFormat: Text.PlainText
        font.pointSize: 30
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignBottom
    }
    //分割线
    Image {

        x: 66
        y: 256
        width: 900
        source: "img/courier19/stripe.png"
    }


    PickUpButton {
        id:pick_up_Button2
        x: 65
        y: 638
        show_text: qsTr("exit")
        MouseArea {
            anchors.rightMargin: -4
            anchors.bottomMargin: -2
            anchors.leftMargin: 4
            anchors.topMargin: 2
            anchors.fill: parent
            onClicked:{
                my_stack_view.pop()
            }
            onEntered:{
                pick_up_Button2.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                pick_up_Button2.show_source = "img/button/7.png"
            }
        }

    }

    PickUpButton {
        id:pick_up_Button1
        x: 685
        y: 638
        show_text: qsTr("一键开锁")

        MouseArea {
            anchors.leftMargin: 4
            anchors.bottomMargin: -2
            anchors.rightMargin: -4
            anchors.fill: parent
            anchors.topMargin: 2
            onClicked:{
                page.enabled = false
                pick_up_Button2.enabled = false
                pick_up_Button1.enabled = false
                up_button.enabled = false
                down_button.enabled = false
                one_key_open_window.open()
            }
            onEntered:{
                pick_up_Button1.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                pick_up_Button1.show_source = "img/button/7.png"
            }
        }
    }

    //上一页
    Rectangle{
        id:up_button
        y:585
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
                gridModel.clear()
                listModel.clear()
                cabinet_data = ""
                down_button.visible = true
                down_button.enabled = true
                press_time = press_time-1
                slot_handler.start_load_mouth_list(press_time)
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
        y:585
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
                gridModel.clear()
                listModel.clear()
                cabinet_data = ""
                up_button.visible = true
                up_button.enabled = true
                press_time = press_time+1
                slot_handler.start_load_mouth_list(press_time)
                if(press_time == page_num){
                    down_button.visible = false
                    down_button.enabled = false
                }
            }
        }
    }


    //点击一键开锁后弹出的对话框
    HideWindow{
        id:one_key_open_window
        Text {

            y:350
            width: 1024
            height: 60
            text: qsTr("是否一键开锁")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //确定一键开锁
        OverTimeButton{
            id:yse
            x:240
            y:560
            show_text:qsTr("Yes")
            show_x:15

            //按钮响应区域
            MouseArea {

                anchors.fill: parent
                onClicked: {
                    if(press != "0"){
                        return
                    }
                    press = "1"
                    slot_handler.start_manager_open_all_mouth()
                    page.enabled = true
                    pick_up_Button2.enabled = true
                    pick_up_Button1.enabled = true
                    up_button.enabled = true
                    down_button.enabled = true
                    one_key_open_window.close()
                    waiting.open()
                    page.enabled = false
                    pick_up_Button2.enabled = false
                    pick_up_Button1.enabled = false
                    up_button.enabled = false
                    down_button.enabled = false
                }
                onEntered:{
                    yse.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    yse.show_source = "img/button/7.png"
                }
            }
        }
        //不一键开锁
        OverTimeButton{
            id:no
            x:540
            y:560
            show_text:qsTr("No")
            show_x:205

            //按钮响应区域
            MouseArea {

                anchors.fill: parent
                onClicked: {
                    page.enabled = true
                    pick_up_Button2.enabled = true
                    pick_up_Button1.enabled = true
                    up_button.enabled = true
                    down_button.enabled = true
                    one_key_open_window.close()
                }
                onEntered:{
                    no.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    no.show_source = "img/button/7.png"
                }
            }
        }


    }

    //等待系统操作提示
    HideWindow{
        id:waiting
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("请稍等...")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
    }

    //设置格口状态成功时显示
    HideWindow{
        id:set_ok
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("Success")
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
                    box_id_list = ""
                    page.enabled = true
                    pick_up_Button2.enabled = true
                    pick_up_Button1.enabled = true
                    up_button.enabled = true
                    down_button.enabled = true
                    set_ok.close()
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

    //设置格口状态失败时显示
    HideWindow{
        id:set_failed
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("操作失败")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:failed_back
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
                    box_id_list = ""
                    page.enabled = true
                    pick_up_Button2.enabled = true
                    pick_up_Button1.enabled = true
                    up_button.enabled = true
                    down_button.enabled = true
                    set_failed.close()
                }
                onEntered:{
                    yse.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    yse.show_source = "img/button/7.png"
                }
            }
        }
    }

    //点击某个格后的界面显示
    HideWindow{
        id:set_box_window

        //所管理的格口的编号
        Text {
            id: text1
            x: 166
            y: 288
            width:120
            height: 50
            color:"#444586"
            font.family:"Microsoft YaHei"
            text: qsTr("编号:")
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WrapAnywhere
            font.pixelSize: 40
        }

        Text {
            font.family:"Microsoft YaHei"
            text:set_box_window_show_box_id
            visible:false
            anchors.horizontalCenterOffset: 810
            color:"#444586"
            font.pixelSize:17
            anchors.centerIn: parent;
        }

        Text {
            id: text2
            x: 281
            y: 288
            width: 30
            height: 50
            color:"#444586"
            font.family:"Microsoft YaHei"
            text: set_box_window_show_id
            font.pixelSize:40
        }
        //分割线
        Image {

            x: 480
            y: 288
            width: 6
            height: 210
            source: "img/manager24/xian.png"
        }
        //箱门类型
        Text {
            id: text6
            x: 574
            y: 288
            width: 100
            height: 50
            color:"#444586"
            font.family:"Microsoft YaHei"
            text: qsTr("箱门类型")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 30
        }
        Image {
            x: 770
            y: 285
            width: 143
            height: 58
            source: "img/18/02.png"

            Text {
                id: boxsize
                x: 0
                y: 0
                width: 143
                height: 58
                color: "#32adb1"
                text: set_box_window_show_boxsize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family:"Microsoft YaHei"
                font.pixelSize: 30
            }
        }
        //箱门编号
        Text {
            id: text7
            x: 574
            y: 371
            width: 100
            height: 50
            color:"#444586"
            font.family:"Microsoft YaHei"
            text: qsTr("箱门编号")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 30
        }
        Image {
            x: 770
            y: 370
            width: 143
            height: 58
            source: "img/18/02.png"

            Text {
                id: boxnum
                x: 0
                y: 0
                width: 143
                height: 58
                color: "#32adb1"
                text: set_box_window_show_boxnum
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family:"Microsoft YaHei"
                font.pixelSize: 30
            }
        }
        //设置使用
        Text {
            id: text8
            x: 574
            y: 448
            width: 143
            height: 50
            color:"#444586"
            font.family:"Microsoft YaHei"
            text: qsTr("设置为")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 30
        }

        Text {
            id: unenable_set
            visible: false
            x: 700
            y: 514
            width: 143
            height: 50
            color:"#444586"
            font.family:"Microsoft YaHei"
            text: qsTr("无法设置已用格口")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 30
        }

        Image {
            x: 770
            y: 453
            width: 140
            height: 50
            source: "img/18/02.png"

            Text {
                id: text3
                x: 0
                y: 0
                width: 143
                height: 58
                color: "#32adb1"
                text: set_box_window_show_box_status
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family:"Microsoft YaHei"
                font.pixelSize: 30
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(set_status_time%2 == 1){
                            set_status_time = set_status_time + 1
                            if(set_box_window_show_box_status == "USED"){
                                set_to_enable.visible = false
                                set_to_locked.visible = false
                                unenable_set.visible = true
                            }
                            if(set_box_window_show_box_status != "USED"){
                                set_to_enable.visible = true
                                set_to_locked.visible = true
                                set_mouth_status_select.open()
                            }
                        }
                        else{
                            set_status_time = set_status_time + 1
                            set_mouth_status_select.close()
                        }
                    }
                }
            }
        }

        //开锁
        HideWindowButton{
            id:manager_service_button
            x: 146
            y: 580
            show_icon:"img/manage25/serviceinfo.png"
            show_text:qsTr("开锁")
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    slot_handler.start_manager_open_mouth(box_id_list)
                    box_id_list = ""
                    page.enabled = true
                    pick_up_Button2.enabled = true
                    pick_up_Button1.enabled = true
                    up_button.enabled = true
                    down_button.enabled = true
                    set_box_window.close()
                    set_mouth_status_select.close()
                    unenable_set.visible = false
                    waiting.open()
                    page.enabled = false
                    pick_up_Button2.enabled = false
                    pick_up_Button1.enabled = false
                    up_button.enabled = false
                    down_button.enabled = false
                }

                onEntered:{
                    manager_service_button.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    manager_service_button.show_source = "img/button/7.png"
                }
            }
        }

        //清空箱子

        HideWindowButton{
            id:manager_service_button1
            x:335
            y: 580
            show_icon:"img/manage25/doormanage.png"
            show_text:qsTr("清空箱体")
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    abc.counter = timer_value
                    my_timer.restart()
                    set_mouth_status_select.close()
                    set_status_time = 1
                    set_box_window.close()
                    set_mouth_status_select.close()
                    unenable_set.visible = false
                    page.enabled = true
                    pick_up_Button2.enabled = true
                    pick_up_Button1.enabled = true
                    up_button.enabled = true
                    down_button.enabled = true
                    coming_soon.open()
                }
                onEntered:{
                    manager_service_button1.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    manager_service_button1.show_source = "img/button/7.png"
                }
            }
        }
        //确定
        HideWindowButton{
            id:manager_service_button2
            x: 524
            y: 580
            show_icon:"img/manage25/error.png"
            show_text:qsTr("确定")
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    slot_handler.start_manager_set_mouth(set_box_window_show_box_id,setbox_status)
                    gridModel.clear()
                    listModel.clear()
                    cabinet_data = ""
                    slot_handler.start_load_mouth_list(1)
                    slot_handler.start_load_manager_mouth_count()
                    set_mouth_status_select.close()
                    set_status_time = 1
                    set_box_window.close()
                    unenable_set.visible = false
                    page.enabled = true
                    pick_up_Button2.enabled = true
                    pick_up_Button1.enabled = true
                    up_button.enabled = true
                    down_button.enabled = true
                }
                onEntered:{
                    manager_service_button2.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    manager_service_button2.show_source = "img/button/7.png"
                }
            }
        }

        //返回
        HideWindowButton{
            id:manager_service_button3
            x: 714
            y: 580
            show_icon:"img/manage25/overduetime.png"
            show_text:qsTr(" return")
            MouseArea {
                anchors.fill: parent
                onClicked:{
                    abc.counter = timer_value
                    my_timer.restart()
                    set_mouth_status_select.close()
                    set_status_time = 1
                    set_box_window.close()
                    unenable_set.visible = false
                    page.enabled = true
                    pick_up_Button2.enabled = true
                    pick_up_Button1.enabled = true
                    up_button.enabled = true
                    down_button.enabled = true
                }
                onEntered:{
                    manager_service_button3.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    manager_service_button3.show_source = "img/button/7.png"
                }
            }
        }

    }
    //点击设置格口状态时弹出的按钮
    HideSelectWindow{
        id:set_mouth_status_select

        Row {
            x: 752
            y: 514
            spacing: 5
            //设置为可用
            HideSelectButton{
                id:set_to_enable
                visible: false
                show_icon:"img/manage25/overduetime.png"
                show_text:qsTr(" ENABLE")
                MouseArea {
                    anchors.fill: parent
                    onClicked:{
                        setbox_status = "ENABLE"
                        set_box_window_show_box_status = "ENABLE"
                        set_mouth_status_select.close()
                        set_status_time = 1
                    }
                    onEntered:{
                        set_to_enable.show_source = "img/bottondown/down_1.png"
                    }
                    onExited:{
                        set_to_enable.show_source = "img/button/7.png"
                    }
                }
            }
            //设置为锁定
            HideSelectButton{
                id:set_to_locked
                visible: false
                show_icon:"img/manage25/overduetime.png"
                show_text:qsTr("锁定")
                MouseArea {
                    anchors.fill: parent
                    onClicked:{
                        setbox_status = "LOCKED"
                        set_box_window_show_box_status = "LOCKED"
                        set_mouth_status_select.close()
                        set_status_time = 1
                    }
                    onEntered:{
                        set_to_locked.show_source = "img/bottondown/down_1.png"
                    }
                    onExited:{
                        set_to_locked.show_source = "img/button/7.png"
                    }
                }
            }
        }
    }


    Component.onCompleted:{
        root.manager_mouth_count_result.connect(mouth_count)
        root.mouth_list_result.connect(show_mouth_list)
        root.load_mouth_list_result.connect(load_list_result)
        root.manager_set_mouth_result.connect(log_text)
        root.manager_open_mouth_by_id_result.connect(log_text)
        root.manager_open_all_mouth_result.connect(log_text)
    }

    Component.onDestruction:{
        root.manager_mouth_count_result.disconnect(mouth_count)
        root.mouth_list_result.disconnect(show_mouth_list)
        root.load_mouth_list_result.disconnect(load_list_result)
        root.manager_set_mouth_result.disconnect(log_text)
        root.manager_open_mouth_by_id_result.disconnect(log_text)
        root.manager_open_all_mouth_result.disconnect(log_text)
    }

    function load_list_result(text){
        waiting.close()
        page.enabled = true
        pick_up_Button2.enabled = true
        pick_up_Button1.enabled = true
        up_button.enabled = true
        down_button.enabled = true
    }

    function show_mouth_list(text){
        cabinet_data = text
        show_cabinet_data(cabinet_data)
    }

    //计算逾期件的数量需要显示多少页，每页显示5条记录
    function count_page(cabinet_num){
        if(cabinet_num/25 > Math.floor(cabinet_num/25)){
            page_num = Math.floor(cabinet_num/25)+1
        }
        else
            page_num = cabinet_num/25
    }

    function mouth_count(text){
        cabinet_num = text
        count_page(text)
        if(text<=25){
            down_button.enabled = false
            down_button.visible = false
        }
        else{
            down_button.enabled = true
            down_button.visible = true
        }
    }

    //解析逾期件的数据，并显示在页面上
    function show_cabinet_data(cabinet_data){
        var obj = JSON.parse(cabinet_data)
        for(var i in obj){
            //格口id
            box_id = obj[i].id
            //格口使用情况
            box_status = obj[i].status
            if(box_status == "ENABLE"){
                show_image_status_temp="img/manage22/freelocker.png"
            }
            else if(box_status == "USED"){
                show_image_status_temp="img/manage22/fulllocker.png"
            }
            else{
                show_image_status_temp="img/manage22/badlocker.png"
            }
            //格口编号
            box_number = obj[i].number
            show_box_number_temp=box_number
            //获得尺寸
            box_size = obj[i].name
            if(box_size=="MINI"){
                show_image_size_temp="img/manage22/a.png"
                show_size_temp="A"
            }
            else if(box_size=="S"){
                show_image_size_temp="img/manage22/b.png"
                show_size_temp="B"
            }
            else if(box_size=="M"){
                show_image_size_temp="img/manage22/c.png"
                show_size_temp="C"
            }
            else{
                show_image_size_temp="img/manage22/d.png"
                show_size_temp="D"
            }
            gridModel.append({"show_image_status":show_image_status_temp , "show_image_size": show_image_size_temp , "show_box_number": show_box_number_temp , "show_size": show_size_temp , "show_box_id":box_id , "show_box_size":box_size , "show_box_status":box_status});
            listModel.append({});
        }
    }

    function log_text(text){
        page.enabled = true
        pick_up_Button2.enabled = true
        pick_up_Button1.enabled = true
        up_button.enabled = true
        down_button.enabled = true
        waiting.close()
        box_id_list = ""
        if(text == 'Success'){
            page.enabled = false
            pick_up_Button2.enabled = false
            pick_up_Button1.enabled = false
            up_button.enabled = false
            down_button.enabled = false
            set_ok.open()
        }
        else{
            page.enabled = false
            pick_up_Button2.enabled = false
            pick_up_Button1.enabled = false
            up_button.enabled = false
            down_button.enabled = false
            set_failed.open()
        }
    }

    //未开发
    HideWindow{
        id:coming_soon
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("即将开放")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:ok_back1
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
                    box_id_list = ""
                    page.enabled = true
                    pick_up_Button2.enabled = true
                    pick_up_Button1.enabled = true
                    up_button.enabled = true
                    down_button.enabled = true
                    coming_soon.close()
                }
                onEntered:{
                    ok_back1.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    ok_back1.show_source = "img/button/7.png"
                }
            }
        }
    }

}
