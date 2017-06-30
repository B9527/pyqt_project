import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    width: 1024
    height: 768
    property var overdue_cost:"0"
    property var paid_amount:"0"

    Component.onCompleted: {
        root.overdue_cost_result.connect(process_result)
        root.paid_amount_result.connect(process_paid_result)
        slot_handler.customer_get_overdue_cost()
        slot_handler.start_pay_cash_for_overdue_express()
    }

    Component.onDestruction: {
        root.overdue_cost_result.disconnect(process_result)
        root.paid_amount_result.disconnect(process_paid_result)
    }

    function process_result(cost){
        overdue_cost = cost
    }

    function process_paid_result(cost){
        paid_amount = cost
    }

    //选择服务选项提示
    Text{
        id:please_select_service
        x:0
        y:164
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
        x: 306
        y: 236
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
        x:344
        y:560
        show_text:qsTr("return")

        MouseArea {
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0

            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))

            }
        }
    }

    Text {
        id: text2
        x: 254
        y: 376
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
        x: 407
        y: 310
        width: 150
        height: 60
        source: "img/courier08/08ground.png"
    }

    //逾期金额
    Text {
        id: textEdit1
        x: 407
        y: 310
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
        x: 407
        y: 448
        width: 150
        height: 60
        source: "img/courier08/08ground.png"
    }

    //投币数量
    Text {
        id: textEdit2
        x: 407
        y: 448
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
        x: 559
        y: 310
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
