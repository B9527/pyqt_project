import QtQuick 2.4
import QtQuick.Controls 1.2

Background{

    property var show_status:""
    property var show_size:""
    property var show_image_status:"img/manage22/fulllocker.png"
    property var show_image_size:"img/manage22/c.png"
    property int timer_value: 60
    property var press: "0"
    property var show_express_image:""
    property var show_image: "img/userselectexpress/k4.png"
    property var choice: "0"

    Stack.onStatusChanged:{
        if(Stack.status == Stack.Activating){
            press = "0"
            abc.counter = timer_value
            my_timer.restart()
   //         show_express_com()
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
    /*******************************************************************************************************************/
    // 页面

    //状态提示

    Text {
        id: text1
        x: 0
        y: 200
        width: 1024
        height: 50
        text: qsTr("Please choose the courier company")
        font.family:"Microsoft YaHei"
        color:"#444586"
        textFormat: Text.PlainText
        font.pointSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
    }
    //分割线
    Image {
        id: image1
        x: 66
        y: 256
        width: 900
        source: "img/courier19/stripe.png"
    }




    PickUpButton {
        id:pick_up_Button2
        x: 65
        y: 638
        show_text: qsTr("back")
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
        show_text: qsTr("OK")

        MouseArea {
            anchors.leftMargin: 4
            anchors.bottomMargin: -2
            anchors.rightMargin: -4
            anchors.fill: parent
            anchors.topMargin: 2
            onClicked:{
                if(press != "0"){
                    return
                }
                press = "1"
                my_stack_view.push(send_input_memory_page)

            }
            onEntered:{
                pick_up_Button1.show_source = "img/bottondown/down_1.png"
            }
            onExited:{
                pick_up_Button1.show_source = "img/button/7.png"
            }
        }
    }


    /*********************************************主页面显示的内容**************************************************************/
    // 页面
    Item  {
        id: page
        x:66
        y:280
        width:1000
        height:200

        GridView{
            id:gridview
            anchors.fill: parent
            delegate: griddel
            model:gridModel
            cellWidth: 235
            cellHeight: 100
            //      flow:Grid.TopToBottom
            interactive: false
            contentX: listview.contentY

        }

        ListView {
            id: listview
            anchors.fill: parent
            model: listmodel
            delegate: delegate
            interactive: false
            orientation:ListView.Vertical
            spacing:235
        }

        // 代理
        Component {
            id: griddel
            Rectangle{
                width: 200
                height: 100
                color: "transparent"
                Image {
                    id: image1
                    width: 200
                    height: 100
                    source: show_express_image

                    Text {
                        id: text1
                        x: 0
                        y: 0
                        width: 50
                        height: 50
                        text:show_text
                        visible: false
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 12
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            choice = show_text
                            abc.counter = timer_value
                            my_timer.restart()
                        }
                        onEntered:{
                            image1.source = "img/bottondown/down_1.png"
                        }
                        onExited:{
                            image1.source = show_express_image
                        }
                    }
                }
            }
        }
        // 模型
        ListModel {
            id: gridModel
            ListElement{//临时效果，直接使用元素方式实现，后续看情况改为配置方式
                show_express_image:"img/userselectexpress/k4.png"
                show_text:"1"
            }
            ListElement{
                show_express_image:"img/userselectexpress/k12.png"
                show_text:"2"
            }
            ListElement{
                show_express_image:"img/userselectexpress/k13.png"
                show_text:"3"
            }
        }

        Component{
            id:delegate
            Rectangle {
                width: 880
                height: 100
                color: "transparent"
            }
        }

        ListModel{
            id:listmodel
        }
    }

    /******************************************主页面显示的内容end*******************************************/
    function show_express_com(){
        for(var i=0;i<15;i++){
            gridModel.append({"show_express_image":show_image,"show_text":i});
            listmodel.append({});

        }


    }
}
