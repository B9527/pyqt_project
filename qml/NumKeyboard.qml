import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle{
    id:full_keyboard
    width:770
    height:280
    color:"transparent"
    signal letter_button_clicked(string str)
    signal function_button_clicked(string str)



    NumButton{
        x:0
        y:0
        show_text:"1"
    }
    NumButton{
        x:100
        y:0
        show_text:"2"
    }
    NumButton{
        x:200
        y:0
        show_text:"3"
    }
    NumButton{
        x:0
        y:75
        show_text:"4"
    }
    NumButton{
        x:100
        y:75
        show_text:"5"
    }
    NumButton{
        x:200
        y:75
        show_text:"6"
    }
    NumButton{
        x:0
        y:150
        show_text:"7"
    }
    NumButton{
        x:100
        y:150
        show_text:"8"
    }
    NumButton{
        x:200
        y:150
        show_text:"9"
    }


    NumButton{
        x:100
        y:225
        show_text:"0"
    }


    NumboardFunctionButton{
        x:200
        y:225
        slot_text:"ok"
        show_image:"img/button/OkButton.png"
    }

    NumboardFunctionButton{
        x:0
        y:225
        slot_text:"delete"
        show_image:"img/button/DeleteButton.png"
    }
}
