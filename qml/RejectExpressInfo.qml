import QtQuick 2.4
import QtQuick.Controls 1.2

Background{

    property var show_name:""
    property var show_phone:""
    property var show_address:""

    property string send_data:'{"id":"f37fa91cf7a211e4b7926c40088b8482","customerStoreNumber":"P201500010001","expressType":"CUSTOMER_STORE","storeUser":{"id":"ace76ad2f7a211e49b736c40088b8482"},"recipientName":"高阳","takeUserPhoneNumber":"18566691650","startAddress":{"id":"48eb7c50f7a311e49ec16c40088b8482","region":{"id":"35865af8f66411e4bd404ef6eab0b474","name":"南山区","parentRegion":{"id":"e4e99678f66311e4bd404ef6eab0b474","name":"鹤岗","parentRegion":{"id":"b3b57ab8f66311e4bd404ef6eab0b474","name":"黑龙江","parentRegion":{"id":"a0bd0d9af66311e4bd404ef6eab0b474","name":"中国"}}}},"detailedAddress":"高新产业园"},"endAddress":{"id":"2494f228f7a311e4bb216c40088b8482","region":{"id":"358b9c7af66411e4bd404ef6eab0b474","name":"宝安区","parentRegion":{"id":"e4ea8862f66311e4bd404ef6eab0b474","name":"深圳","parentRegion":{"id":"b3b582cef66311e4bd404ef6eab0b474","name":"广东","parentRegion":{"id":"a0bd0d9af66311e4bd404ef6eab0b474","name":"中国"}}}},"detailedAddress":"任达科技园"},"rangePrice":{"id":"a4ded9a6f7a011e48bfb6c40088b8482","businessType":{"id":"ca6ef91cf7a011e490516c40088b8482","name":"今日送"},"startRegion":{"id":"35865af8f66411e4bd404ef6eab0b474","name":"南山区","parentRegion":{"id":"e4e99678f66311e4bd404ef6eab0b474","name":"鹤岗","parentRegion":{"id":"b3b57ab8f66311e4bd404ef6eab0b474","name":"黑龙江","parentRegion":{"id":"a0bd0d9af66311e4bd404ef6eab0b474","name":"中国"}}}},"endRegion":{"id":"358b9c7af66411e4bd404ef6eab0b474","name":"宝安区","parentRegion":{"id":"e4ea8862f66311e4bd404ef6eab0b474","name":"深圳","parentRegion":{"id":"b3b582cef66311e4bd404ef6eab0b474","name":"广东","parentRegion":{"id":"a0bd0d9af66311e4bd404ef6eab0b474","name":"中国"}}}},"firstHeavy":5000,"firstPrice":1000,"continuedHeavy":1000,"continuedPrice":200},"version":0,"status":"IMPORTED"}'
    property string chargeType:"BY_WEIGHT"
    property string designationSize: "S"
    property int payOfAmount:0

    width: 1024
    height: 768


    //已进入逾期件页面就加载逾期件
    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            show_recive_info(send_data)
        }

        if(Stack.status==Stack.Deactivating){

        }
    }
    /****************************************功能按钮****************************************************/
    //取消并退出
    DoorButton{
        id:back_button
        y:620
        x:60
        show_text:qsTr("cencel")
        show_image:"img/door/2.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 1) return true }))
            }
            onEntered:{
                back_button.show_image = "img/door/down_2.png"
            }
            onExited:{
                back_button.show_image = "img/door/2.png"
            }
        }
    }
    //同意并确定
    DoorButton{
        id:ok_button
        y:620
        x:660
        show_text:qsTr("OK")
        show_image:"img/door/2.png"
        //按钮响应区域
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(chargeType == "BY_WEIGHT"){
                    my_stack_view.push(reject_express_weigh_page)
                }
                if(chargeType == "NOT_CHARGE"){
                    slot_handler.start_choose_mouth_size(designationSize,"customer_store_express")
                }
                if(chargeType == "FIXED_VALUE"){
                    if(payOfAmount == 0){
                        no_payOfAmount.open()
                    }
                    if(payOfAmount != 0){
                        slot_handler.start_free_mouth_by_size(designationSize)
                    }
                }
            }
            onEntered:{
                ok_button.show_image = "img/door/down_2.png"
            }
            onExited:{
                ok_button.show_image = "img/door/2.png"
            }
        }
    }

    /************************************信息显示区***************************************************/

    Row {
        x: 115
        y: 304
        spacing: 20

        Column {

            Text {
                id: text1
                text: qsTr("name:")
                font.family:"Microsoft YaHei"
                color:"#444586"
                font.pixelSize: 30
            }

            Text {
                id: text3
                text: qsTr("phone:")
                font.family:"Microsoft YaHei"
                color:"#444586"
                font.pixelSize: 30
            }

            Text {
                id: text2
                text: qsTr("address:")
                font.family:"Microsoft YaHei"
                color:"#444586"
                font.pixelSize: 30
            }
        }

        Column {
            spacing: 10

            Text {
                id: text4
                text: show_name
                font.family:"Microsoft YaHei"
                color:"#444586"
                font.pixelSize: 24
            }

            Text {
                id: text5
                text: show_phone
                font.family:"Microsoft YaHei"
                color:"#444586"
                font.pixelSize: 24
            }
            Text {
                id: text6
                x: 0
                y: 22
                text: show_address
                font.family:"Microsoft YaHei"
                color:"#444586"
                font.pixelSize: 24
            }
        }
    }

    Text {
        id: text7
        x: 115
        y: 205
        text: qsTr("The recipient informations ")
        font.family:"Microsoft YaHei"
        color:"#444586"
        font.pixelSize: 30
    }


    /*********************************************数据解析*************************************/
    Component.onCompleted: {
        root.choose_mouth_result.connect(handle_text)
        root.free_mouth_by_size_result.connect(check_free_mouth)
    }

    Component.onDestruction: {
        root.choose_mouth_result.disconnect(handle_text)
        root.free_mouth_by_size_result.disconnect(check_free_mouth)
    }

    //解析逾期件的数据，并显示在页面上
    function show_recive_info(send_data){
        if(send_data==""){
            return
        }
        var a = JSON.parse(send_data)
        show_name = a.recipientName
        show_phone = a.recipientUserPhoneNumber
        show_address = a.endAddress
        chargeType = a.chargeType
        if(chargeType == "FIXED_VALUE"){
            payOfAmount = a.payOfAmount
            designationSize = a.designationSize
        }
        if(a.chargeType == "NOT_CHARGE"){
            designationSize = a.designationSize
        }
    }

    function check_free_mouth(text){
        if(text == "Failure"){
            ok_button.enabled = false
            back_button.enabled = false
            not_mouth.open()
        }
        if(text == "Success"){
            slot_handler.start_pull_pre_pay_cash_for_customer_reject_express(payOfAmount)
            my_stack_view.push(reject_pay_ment_page,{designationSize:designationSize})
        }
    }

    function handle_text(text){
        if(text == 'Success'){
            my_stack_view.push(reject_Door_open_page)
        }
        if(text == 'NotMouth'){
            ok_button.enabled = false
            back_button.enabled = false
            not_mouth.open()
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
                    ok_button.enabled = true
                    back_button.enabled = true
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
    //当前没有格口
    HideWindow{
        id:no_payOfAmount
        Text {
            y:350
            width: 1024
            height: 60
            text: qsTr("no_payOfAmount")
            font.family:"Microsoft YaHei"
            color:"#444586"
            textFormat: Text.PlainText
            font.pointSize:45
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
        //返回
        OverTimeButton{
            id:no_payOfAmount_back
            x:350
            y:560
            show_text:qsTr("back")
            show_x:15

            //按钮响应区域
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    ok_button.enabled = true
                    back_button.enabled = true
                    no_payOfAmount.close()
                }
                onEntered:{
                    no_payOfAmount_back.show_source = "img/bottondown/down_1.png"
                }
                onExited:{
                    no_payOfAmount_back.show_source = "img/button/7.png"
                }
            }
        }
    }
}
