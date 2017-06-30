import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    id: rectangle1
    width:300
    height:60
    property var show_image:""
    color:"transparent"
    property var show_text:""
    property var bool:false


    //按钮蓝底
    Image{
        x:0
        y:0
        width:300
        height:60
        source:"img/courier08/08ground.png"
    }

    //按钮图标
    Image{
        x:10
        y:15
        width:25
        height:30
        source:show_image
    }
    //按钮图标
    Image{
        x:40
        y:15
        width:5
        height:30
        source:"img/courier08/08cut.png"
    }

    //这里是哪个文本框
    TextInput{
        y:10
        width: 227
        height: 39
        cursorVisible: bool
        color:"#ffffff"
        text: show_text
        clip: true
        anchors.leftMargin: 60
        echoMode :TextInput.Password
        focus: true
        font.family:"Microsoft YaHei"
        font.pixelSize:30
        anchors.left: parent.left
    }



}
