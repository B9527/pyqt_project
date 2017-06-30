import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    width: 1024
    height: 768
    property var overdue_cost:"0"
    property var paid_amount:"0"
    property string designationSize: "NULL"

    Stack.onStatusChanged:{
            if(Stack.status == Stack.Activating){

            }
            if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止

            }
        }

    Component.onCompleted: {
        slot_handler.start_get_customer_express_cost()
        slot_handler.start_pay_cash_for_customer_express()
        root.customer_express_cost_insert_coin_result.connect(process_result)
        root.paid_amount_result.connect(process_paid_result)
        root.choose_mouth_result.connect(handle_text)
    }

    Component.onDestruction: {
        root.customer_express_cost_insert_coin_result.disconnect(process_result)
        root.paid_amount_result.disconnect(process_paid_result)
        root.choose_mouth_result.disconnect(handle_text)
        slot_handler.stop_pay_cash_for_customer_express()
    }

    function process_result(cost){
        overdue_cost = cost
        page_change()
    }

    function process_paid_result(cost){
        paid_amount = cost
        page_change()

    }

    function page_change(){
        if(paid_amount == overdue_cost && overdue_cost != 0){
            if(designationSize == "NULL"){
                my_stack_view.push(send_select_box)
            }
            if(designationSize != "NULL"){
                slot_handler.start_choose_mouth_size(designationSize,"customer_store_express")
            }
        }
    }

    function handle_text(text){
        if(text == 'Success'){
            my_stack_view.push(send_door_open_page)
        }
    }

    //选择服务选项提示
    Text{
        id:please_select_service
        x:0
        y:167
        width: 1024
        height: 60
        font.bold: true
        text:qsTr("Welcome to use the system")
        font.family:"Microsoft YaHei"
        horizontalAlignment: Text.AlignHCenter
        color:"#444586"
        font.pixelSize:51
    }



    Text {
        id: text1
        x: 311
        y: 244
        width: 300
        height: 60
        color:"#444586"
        font.family:"Microsoft YaHei"
        text: qsTr("You pay the overdue amount")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 30
    }

    //返回按钮
    BackButton{
        x:365
        y:550
        show_text:qsTr("return")

        MouseArea {

            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))

            }
        }
    }

    Text {
        id: text2
        x: 270
        y: 392
        width: 370
        height: 60
        color: "#444586"
        text: qsTr("Please put a coin in the slot")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 30
        font.family: "Courier"
    }

    Image {
        id: image1
        x: 430
        y: 320
        width: 150
        height: 60
        source: "img/courier08/08ground.png"
    }

    //逾期金额
    Text {
        id: textEdit1
        x: 430
        y: 320
        width: 150
        height: 60
        text: overdue_cost
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color:"White"
        font.pixelSize: 30
    }

    Image {
        id: image2
        x: 430
        y: 464
        width: 150
        height: 60
        source: "img/courier08/08ground.png"
    }

    //投币数量
    Text {
        id: textEdit2
        x: 430
        y: 464
        width: 150
        height: 60
        color:"White"
        text: paid_amount
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 30
    }

    Text {
        id: text3
        x: 586
        y: 320
        width: 81
        height: 60
        color: "#444586"
        text: qsTr("yuan")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 30
        verticalAlignment: Text.AlignVCenter
        font.family: "Microsoft YaHei"
    }
}
