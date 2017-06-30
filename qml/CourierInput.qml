import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    width:300
    height:60
    property var show_image:""
    color:"transparent"
    property var show_text:""
    property var bool:true

    //按钮蓝底
    Image{
        x:0
        y:0
        width:300
        height:60
        source:"img/courier08/08ground.png"
    }


    TextInput{
        x:60
        y:12
        width: 224
        height: 39
        text:show_text
        clip: true
        visible: true
        cursorVisible: bool
        color:"#ffffff"
        focus: true
        font.family:"Microsoft YaHei"
        font.pixelSize:30
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
}
