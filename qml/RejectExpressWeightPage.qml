import QtQuick 2.4
import QtQuick.Controls 1.2

/*
功能：寄件称重界面18
author:caitao
*/

Background{
    property int timer_value: 120
    property var press:"0"

    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
            slot_handler.start_calculate_customer_reject_express_cost()
        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
            slot_handler.stop_calculate_customer_reject_express_cost()
        }
    }

    Image {
        x: 123
        y: 220
        width: 268
        height: 501
        source: "img/18/01.png"
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

    Image {
        x: 667
        y: 399
        width: 143
        height: 58
        source: "img/18/02.png"

        Text {
            id: express_kg
            x: 0
            y: 0
            width: 143
            height: 58
            color: "#32adb1"
            text: qsTr("0")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family:"Microsoft YaHei"
            font.pixelSize: 45
        }
    }

    Image {
        x: 667
        y: 472
        width: 143
        height: 58
        source: "img/18/02.png"

        Text {
            id: express_cost
            x: 0
            y: 0
            width: 143
            height: 58
            color: "#32adb1"
            text: qsTr("0")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family:"Microsoft YaHei"
            font.pixelSize: 45
        }
    }

    Image {
        id:cancel_button
        x: 485
        y: 605
        width: 198
        height: 81
        source: "img/button/9.png"

        Text {
            id: text3
            x: 0
            y: 0
            width: 198
            height: 81
            color: "#ffffff"
            text: qsTr("Cancel and Exit")
            font.family:"Microsoft YaHei"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 30
        }

        MouseArea {
            anchors.bottomMargin: 14
            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 1) return true }))
            }

            onEntered:{
                cancel_button.source = "img/05/pushdown.png"
            }
            onExited:{
                cancel_button.source = "img/button/9.png"
            }
        }
    }

    Text {
        x: 485
        y: 255
        color: "#444586"
        text: qsTr("Please put the package into ths platform")
        font.family:"Microsoft YaHei"
        font.pixelSize: 24
    }

    Text {
        x: 485
        y: 300
        color: "#444586"
        text: qsTr("The system will calculate the postage for you")
        style: Text.Normal
        font.bold: false
        font.family:"Microsoft YaHei"
        font.pixelSize: 24
    }

    Text {
        x: 485
        y: 399
        color: "#444586"
        text: qsTr("Weight")
        font.bold: false
        font.family:"Microsoft YaHei"
        font.pixelSize: 45
    }

    Text {
        x: 485
        y: 472
        color: "#444586"
        text: qsTr("Cost")
        font.family:"Microsoft YaHei"
        font.pixelSize: 45
    }

    Image {
        id:continue_button
        x: 699
        y: 605
        width: 198
        height: 81
        source: "img/button/9.png"

        Text {
            id: text4
            x: 0
            y: 0
            width: 198
            height: 81
            color: "#fbfbfb"
            text: qsTr("Continue")
            font.family:"Microsoft YaHei"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 30
        }

        MouseArea {
            anchors.bottomMargin: 14
            anchors.fill: parent
            onClicked: {
                if(express_kg.text != 0){
                    if(press != "0"){
                        return
                    }
                    press = "1"
                    my_timer.stop()
                    my_stack_view.push(reject_pay_ment_page)
                }
            }
            onEntered:{
                continue_button.source = "img/05/pushdown.png"
            }
            onExited:{
                continue_button.source = "img/button/9.png"
            }
        }
    }

    Text {
        id: text1
        x: 816
        y: 406
        color: "#444586"
        text: qsTr("Kg")
        font.pixelSize: 45
    }

    Text {
        id: text2
        x: 816
        y: 479
        color: "#444586"
        text: qsTr("Yuan")
        font.pixelSize: 45
    }

    Component.onCompleted: {
        root.customer_store_express_cost_result.connect(show_weight)
    }

    Component.onDestruction: {
        root.customer_store_express_cost_result.disconnect(show_weight)
    }
    function show_weight(text){
        var b =  JSON.parse(text)

        express_kg.text = b.heavy/1000
        express_cost.text = b.cost/100
    }

}
