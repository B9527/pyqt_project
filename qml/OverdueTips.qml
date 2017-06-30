import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    id: background1

    property int timer_value: 60

    //初始化页面
    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            abc.counter = timer_value
            my_timer.restart()
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

    BackButton{
        id:develop_back_button
        x:365
        y:550
        show_text:qsTr("return")

        MouseArea {

            anchors.fill: parent
            onClicked: {
                my_stack_view.pop(my_stack_view.find(function(item){if(item.Stack.index === 0) return true }))
            }
            onEntered:{
                develop_back_button.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                develop_back_button.show_source = "img/button/7.png"
            }
        }
    }

    Column {
        id: column1
        x: 57
        y: 198
        spacing: 20
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: develop_back_button.horizontalCenter

        Text {
            id: text1
            x: 0
            width: 900
            text: qsTr("The collecting period of your goodsin the self-service locker just reached.")
            font.family:"Microsoft YaHei"
            horizontalAlignment: Text.AlignHCenter
            color:"#444586"
            font.pixelSize:45
            wrapMode: Text.WordWrap
        }

        Text {
            id: text2
            x: 0
            width: 900
            text: qsTr("The merchandise will be shipped to the E LINK redemption centre. ")
            font.family:"Microsoft YaHei"
            horizontalAlignment: Text.AlignHCenter
            color:"#444586"
            font.pixelSize:45
            wrapMode: Text.WordWrap
        }

        Text {
            id: text3
            x: 0
            y: 0
            text: qsTr("Enquiry: 36696320")
            anchors.horizontalCenter: parent.horizontalCenter
            font.family:"Microsoft YaHei"
            horizontalAlignment: Text.AlignHCenter
            color:"#444586"
            font.pixelSize:45
            wrapMode: Text.WrapAnywhere
        }
    }

}
