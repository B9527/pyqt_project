import QtQuick 2.4
import QtQuick.Controls 1.2

Background{
    id:ad

    property int pic_number
    property var pic
    property var qml_pic
    property string pic_source: ""
    property var num: 0

    Stack.onStatusChanged:{
        if(Stack.status==Stack.Activating){
            slot_handler.start_get_ad_file()

        }
        if(Stack.status==Stack.Deactivating){//不在当前页面时，定时器停止
            my_timer.stop()
        }
        if(Stack.status==Stack.Active){

        }
    }

    Timer{//定时器，时间到后，进行图片
        id:my_timer
        interval:5000
        repeat:true
        running:false
        triggeredOnStart:false
        onTriggered:{
            if(num < pic_number){
                num = num + 1
                if(num == pic_number){
                    my_timer.restart()
                    loader.sourceComponent = loader.Null
                    pic_source = "../advertisement/source/" + qml_pic[0]
                    loader.sourceComponent = component
                    num = 0

                }
                else{
                    my_timer.restart()
                    loader.sourceComponent = loader.Null
                    pic_source = "../advertisement/source/" + qml_pic[num]
                    loader.sourceComponent = component
                }
            }
        }
    }

    Component {
        id: component
        Rectangle {
            Image {
                id:ad_pic
                x: 0
                y: 0
                width: 1023
                height: 768
                source: pic_source
            }
        }
    }
    Loader { id: loader }

    Component {
        id: component_temp
        Rectangle {
            Image {
                id:ad_pic_temp
                x: 0
                y: 0
                width: 1023
                height: 768
                source: pic_source
            }
        }
    }
    Loader { id: loader_temp }

    function data_to_json(text){
        var obj = JSON.parse(text)
        qml_pic = obj
        loader.sourceComponent = loader.Null
        pic_source = "../advertisement/source/" + qml_pic[0]
        loader.sourceComponent = component
        my_timer.start()
    }


    Component.onCompleted: {
        root.ad_download_result.connect(update_ad_source)
        root.ad_source_result.connect(data_to_json)
        root.ad_source_number_result.connect(source_number)
        root.delete_result.connect(delete_ad_source)
    }

    Component.onDestruction: {
        root.ad_download_result.disconnect(update_ad_source)
        root.ad_source_result.disconnect(data_to_json)
        root.ad_source_number_result.disconnect(source_number)
        root.delete_result.disconnect(delete_ad_source)
    }

    function source_number(text){
        pic_number = text
    }

    function update_ad_source(text)
    {
        if(text == "ok"){
            slot_handler.start_get_ad_file()
        }
    }

    function delete_ad_source(text)
    {
        if(text == "ok"){
            slot_handler.start_get_ad_file()
        }
    }


    MouseArea {
        anchors.fill: parent
        onClicked: {
            my_stack_view.push(select_language_view)
        }
    }

    Column {
        x: 0
        y: 636
        spacing: 11
        scale: 1

        Text{
            id:order
            width: 1022
            height: 50
            text:qsTr("Click to enter the system")
            style: Text.Sunken
            horizontalAlignment: Text.AlignHCenter
            color:"#444586"
            font.family:"Microsoft YaHei"
            font.pixelSize:30
        }

        Text{
            id:order1
            width: 1022
            height: 50
            text:qsTr("Click to enter the system _en")
            style: Text.Sunken
            horizontalAlignment: Text.AlignHCenter
            color:"#444586"
            font.family:"Microsoft YaHei"
            font.pixelSize:30
        }
    }

}

