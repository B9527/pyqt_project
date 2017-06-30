import QtQuick 2.4
import QtQuick.Controls 1.2


Rectangle {
    id:root
    width: 1024
    height: 768

    signal customer_take_express_result(string str)
    signal mouth_number_result(string str)
    signal overdue_cost_result(string str)
    signal user_login_result(string str)
    signal get_version_result(string str)

    signal barcode_result(string str)
    signal store_express_result(string str)
    signal phone_number_result(string str)

    signal paid_amount_result(string str)

    signal user_info_result(string str)
    signal customer_store_express_result(string str)
    signal mouth_status_result(string str)
    signal get_oainfo_result(string str)
    signal get_oainfo_result_message(string str)

    signal customer_take_express_disks_result(string str)
    signal customer_take_express_disks_result_message(string str)
    signal check_oa1_result(string str)

    signal overdue_express_list_result(string str)
    signal overdue_express_count_result(int i)
    signal load_express_list_result(string str)

    signal init_client_result(string str)

    signal courier_take_overdue_express_result(string str)

    signal customer_store_express_cost_result(string str)

    signal customer_express_cost_insert_coin_result(string str)

    signal store_customer_express_result_result(string str)

    signal send_express_list_result(string str)
    signal send_express_count_result(int i)
    signal take_send_express_result(string str)

    signal manager_mouth_count_result(int i)
    signal load_mouth_list_result(string str)
    signal mouth_list_result(string str)
    signal manager_set_mouth_result(string str)
    signal manager_open_mouth_by_id_result(string str)

    signal courier_get_user_result(string str)

    signal manager_open_all_mouth_result(string str)

    signal choose_mouth_result(string str)

    signal free_mouth_result(string str)

    signal free_mouth_by_size_result(string str)

    signal imported_express_result(string str)

    signal customer_reject_express_result(string str)

    signal reject_express_count_result(int i)

    signal take_reject_express_result(string str)

    signal reject_express_list_result(string str)

    signal reject_express_result(string str)

    signal manager_get_box_info_result(string str)

    signal ad_download_result(string str)

    signal ad_source_result(string str)

    signal ad_source_number_result(string str)

    signal delete_result(string str)


    StackView {
        id: my_stack_view
        anchors.fill: parent
        initialItem: select_service_view   //ad_page

        delegate: StackViewDelegate {
            function transitionFinished(properties)
            {
                properties.exitItem.opacity = 1
            }

            pushTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "opacity"
                    from: 0
                    to: 1
                }
                PropertyAnimation {
                    target: exitItem
                    property: "opacity"
                    from: 1
                    to: 0
                }
            }
        }
    }



    Component {
        id:select_service_view
        SelectServicePage{
        }
    }
     //用户寄件输入单号页面
    Component{
        id:send_input_memory_page
        SendInputMemoryPage{

        }
    }
    //用户寄件输入用户名界面
    Component{
        id:send_input_username_page
        SendInputUsernamePage{

        }
    }
    //用户寄件选择格口页面
    Component{
        id:send_select_box
        SendSelectBoxSizePage{

        }
    }
    //用户寄件格口打开页面
    Component{
        id:send_door_open_page
        SendDoorOpenPage{

        }
    }


    Component{
        id:customer_scan_qr_code_view
        CustomerScanQrCodePage{
        }
    }

    Component{
        id:manager_cabinet_view
        ManagerCabinetPage{
        }
    }

    Component{
        id:customer_take_express_view
        CustomerTakeExpressPage{

        }
    }

    //存件柜门打开界面
    Component{
        id:door_open_view
        DoorOpenPage{
        }
    }



    //快递员登录的界面
    Component{
        id:background_login_view
        BackgroundLoginPage{

        }
    }
    //用户名登录不正确谈出来的界面
    Component{
        id:courier_psw_error_view
        CourierPswErrorPage{

        }
    }
    //快递员操作的界面
    Component{
        id:courier_service_view
        CourierServicePage{

        }
    }
    //快递员存件输入快递单号界面
    Component{
        id:courier_memory_view
        CourierMemoryPage{

        }

    }


    //快递员输入用户电话号码界面
    Component{
        id:courier_input_phone_view
        CourierInputPhonePage{

        }

    }

    //取件成功，打开箱门界面06
    Component{
        id:customer_take_express_opendoor_view
        OpenDoorPage{
        }
    }

    //快件超过免费时段界面05
    Component{
        id:customer_take_express_overtime_view
        OverTimePage{
        }
    }

    //快件超过免费时段支付类型界面26
    Component{
        id:customer_take_express_payment_view
        PayMentPage{
        }
    }

    //验证码不正确页面07
    Component{
        id:customer_take_express_error_view
        PassWordErrorPage{
        }
    }

    //快递员确定手机号码界面
    Component{
        id:courier_input_phone_sure_view
        CourierInputPhoneSurePage{

        }

    }
    //快递员选择隔口尺寸界面
    Component{
        id:courier_select_box_size_view
        CourierSelectBoxSizePage{

        }

    }

    //寄件称重界面
    Component{
        id:customer_send_express_view
        SendExpressWeightPage{

        }

    }
    //快递员取逾期件界面
    Component{
        id:background_overdue_time_view
        BackgroundOverdueTimePage{

        }

    }
    //管理员操作界面
    Component{
        id:manager_service_view
        ManagerServicePage{

        }
    }
    //用户操作退出界面
    Component{
        id:user_quit_view
        UserQuitPage{

        }
    }
    //存件帮助界面
    Component{
        id:user_select_view
        LockerHelpPage{
        }
    }


    //用户选择快递公司页面
    Component{
        id:user_select_express_page
        UserSelectExpressPage{
        }
    }



    //用户寄件选择支付方式页面
    Component{
        id:send_pay_page
        SendPayMentPage{

        }
    }

    //用户寄件投币页面
    Component{
        id:send_inser_coin_pagee
        SendInserCoinPage{

        }
    }

    //用户寄件地址页面
    Component{
        id:send_express_info
        SendExpressInfo{

        }
    }

    //用户寄件地址页面
    Component{
        id:send_express_help
        SendExpressHelp{

        }
    }



    //功能开发中的提示页面
    Component{
        id:on_develop_view
        OnDevelopPage{
        }
    }

    // 投放硬币界面
    Component{
        id:input_coin_view
        InsertCoinPage{

        }
    }

    Component{
        id:box_manage_page
        ManageInitPage{

        }
    }
    //挂盘成功查询
    Component{
        id:oa_init_page
        OAInitPage{

        }
    }
    //卸载硬盘查询
    Component{
        id:customer_take_express_disks_page
        CustomerTakeExpressDisksPage{

        }
    }

    //用户使用协议
    Component{
        id:user_agreement_page
        UserAgreementPage{

        }
    }

    //用户使用协议
    Component{
        id:manage_take_overdue_page
        ManagerTakeOverdueExpressPage{

        }
    }

    //快递员取寄件功能
    Component{
        id:take_send_express_page
        TakeSendExpress{

        }
    }



    //用户退件输入运单号页面
    Component{
        id:reject_input_memory_page
        RejectInputMemoryPage{
        }
    }

    //用户退件，格口打开页面
    Component{
        id:reject_Door_open_page
        RejectDoorOpenPage{
        }
    }

    //用户退件，格口打开页面中的帮助页面
    Component{
        id:reject_express_help
        RejectExpressHelp{
        }
    }

    //用户退件，退件信息显示页面
    Component{
        id:reject_express_info
        RejectExpressInfo{
        }
    }

    //用户退件，称重页面
    Component{
        id:reject_express_weigh_page
        RejectExpressWeightPage{
        }
    }

    //用户退件，投币页面
    Component{
        id:reject_insert_coin_page
        RejectInsertCoinPage{
        }
    }

    //用户退件，选择支付方式页面
    Component{
        id:reject_pay_ment_page
        RejectPayMentPage{
        }
    }

    //用户退件，选择支付方式页面
    Component{
        id:reject_select_box_size_page
        RejectSelectBoxSizePage{
        }
    }

    //用户退件，选择支付方式页面
    Component{
        id:take_reject_express
        TakeRejectExpress{
        }
    }

    //用户取逾期件时的提示
    Component{
        id:overdue_tips_page
        OverdueTips{
        }
    }

    //ad
    Component{
        id:ad_page
        Advertisement{
        }
    }

}
