# coding：utf-8

import json
import logging
import math
import random
import datetime
import time

from PyQt5.QtCore import QObject, pyqtSignal

import ClientTools
import box.service.BoxService
import box.repository.BoxDao
import company.service.CompanyService
import company.repository.CompanyDao
from network import HttpClient
import user.service.UserService
from device import Scanner
from device import CoinMachine
from express.repository import ExpressDao
from device import WeighingMachine

__author__ = "gaoyang"


class ExpressSignalHandler(QObject):
    customer_take_express_signal = pyqtSignal(str)
    overdue_cost_signal = pyqtSignal(str)
    barcode_signal = pyqtSignal(str)
    store_express_signal = pyqtSignal(str)
    phone_number_signal = pyqtSignal(str)
    paid_amount_signal = pyqtSignal(str)
    customer_store_express_signal = pyqtSignal(str)
    about_oainfo_express_signal = pyqtSignal(str)

    overdue_express_list_signal = pyqtSignal(str)
    overdue_express_count_signal = pyqtSignal(int)

    customer_take_express_disks_signal = pyqtSignal(str)
    customer_take_express_disks_message_signal = pyqtSignal(str)
    check_oa1_result_signal = pyqtSignal(str)

    staff_take_overdue_express_signal = pyqtSignal(str)
    load_express_list_signal = pyqtSignal(str)

    customer_store_express_cost_signal = pyqtSignal(str)
    store_customer_express_result_signal = pyqtSignal(str)
    customer_express_cost_insert_coin_signal = pyqtSignal(str)

    send_express_list_signal = pyqtSignal(str)
    send_express_count_signal = pyqtSignal(int)
    staff_take_send_express_signal = pyqtSignal(str)
    imported_express_result_signal = pyqtSignal(str)
    customer_reject_express_signal = pyqtSignal(str)
    reject_express_signal = pyqtSignal(str)
    reject_express_list_signal = pyqtSignal(str)


logger = logging.getLogger()

express_signal_handler = ExpressSignalHandler()

barcode_run_flag = False
barcode_start = False
overdue_cost = 0


def init_express(param, mouth, box_param):
    try:
        express = {"id": param["id"], "expressType": param["expressType"], "status": param["status"],
                   "storeTime": param["storeTime"], "syncFlag": 1, "version": param["version"],
                   "box_id": mouth["box_id"],
                   "logisticsCompany_id": ClientTools.get_value("id", ClientTools.get_value("logisticsCompany", param)),
                   "operator_id": box_param["operator_id"], "mouth_id": mouth["id"],
                   "storeUser_id": ClientTools.get_value("id", ClientTools.get_value("storeUser",
                                                                                     param)),
                   "groupName": load_param_or_default("groupName", param),
                   "expressNumber": load_param_or_default("expressNumber", param),
                   "customerStoreNumber": load_param_or_default("customerStoreNumber", param),
                   "overdueTime": load_param_or_default("overdueTime", param),
                   "takeUserPhoneNumber": load_param_or_default("takeUserPhoneNumber", param),
                   "storeUserPhoneNumber": ClientTools.get_value("phoneNumber",
                                                                 ClientTools.get_value("storeUser", param)),
                   "validateCode": load_param_or_default("validateCode", param),
                   "designationSize": load_param_or_default("designationSize", param),
                   "chargeType": load_param_or_default("chargeType", param),
                   "continuedHeavy": load_param_or_default("continuedHeavy", param),
                   "endAddress": load_param_or_default("endAddress", param),
                   "continuedPrice": load_param_or_default("continuedPrice", param),
                   "startAddress": load_param_or_default("startAddress", param),
                   "firstHeavy": load_param_or_default("firstHeavy", param),
                   "firstPrice": load_param_or_default("firstPrice", param),
                   "payOfAmount": load_param_or_default("payOfAmount", param),
                   "electronicCommerce_id": ClientTools.get_value("id",
                                                                  ClientTools.get_value("electronicCommerce", param)),
                   "takeUser_id": ClientTools.get_value("id", ClientTools.get_value("takeUser", param)),
                   "payAmount": ClientTools.get_value("payAmount", param),
                   "payType": ClientTools.get_value("payType", param),
                   "order_id": ClientTools.get_value("order_id", param)}
        ExpressDao.init_express(express)
        if express["electronicCommerce_id"] is not None:
            company_list = company.repository.CompanyDao.get_company_by_id({"id": express["electronicCommerce_id"]})
            electronic_commerce = {"id": express["electronicCommerce_id"],
                                   "companyType": "ELECTRONIC_COMMERCE",
                                   "name": param["electronicCommerce"]["name"], "deleteFlag": 0,
                                   "parentCompany_id": ClientTools.get_value("parentCompany_id",
                                                                             param["electronicCommerce"],
                                                                             None)}
            if len(company_list) == 0:
                company.repository.CompanyDao.insert_company(electronic_commerce)
            else:
                company.repository.CompanyDao.update_company(electronic_commerce)
    except Exception as e:
        logger.error(("init_express ERROR :", e))
        box.service.BoxService.BoxSignalHandler.init_client_signal.emit("ERROR")


def load_param_or_default(key, dict_, default_value=None):
    if key in dict_.keys():
        return dict_[key]
    return default_value


def start_barcode_take_express():
    global barcode_start
    if barcode_start:
        return
    barcode_start = True
    Scanner.scanner_signal_handler.barcode_result.connect(get_express_barcode_text)
    Scanner.start_get_text_info()


def stop_barcode_take_express():
    global barcode_start
    if not barcode_start:
        return
    barcode_start = False
    Scanner.scanner_signal_handler.barcode_result.disconnect(get_express_barcode_text)
    Scanner.start_stop_scanner()


customer_take_express_validate_code = ''


def start_customer_take_express(validate):
    ClientTools.get_global_pool().apply_async(customer_take_express, (validate,))


def customer_take_express(validate_code):
    logger.info(validate_code)
    global customer_take_express_validate_code
    customer_take_express_validate_code = validate_code
    print('customer_take_express_validate_code:', customer_take_express_validate_code)
    param = {"validateCode": validate_code, "status": "IN_STORE"}
    expresses = ExpressDao.get_express_by_validate(param)

    pre_take_express(expresses)


def start_customer_take_express_disks():
    ClientTools.get_global_pool().apply_async(customer_take_express_disks)


def customer_take_express_disks():
    global customer_take_express_validate_code
    param = {"validateCode": customer_take_express_validate_code, "status": "IN_STORE"}
    expressNumber = ExpressDao.get_take_aID_by_validate(param)
    __data = {"expressNumber": expressNumber, "validateCode": customer_take_express_validate_code}
    message, status_code = HttpClient.post_message("genomics/umount", __data)
    print("xiezai:", status_code)
    print(message)
    if status_code == 200:
        if message['status'] == '0':
            express_signal_handler.customer_take_express_disks_signal.emit("Success")
        else:
            express_signal_handler.customer_take_express_disks_signal.emit("False")
            # 回显失败原因
            express_signal_handler.customer_take_express_disks_message_signal.emit(message['msg'])
    else:
        express_signal_handler.customer_take_express_disks_signal.emit("Net_error")


def get_express_barcode_text(text_info):
    global barcode_start
    if not barcode_start:
        return
    barcode_start = False
    if text_info == "ERROR":
        return
    if text_info == "":
        express_signal_handler.customer_take_express_signal.emit("NotInput")
        return
    if text_info.find("|") == -1:
        express_signal_handler.customer_take_express_signal.emit("Error")
        return
    express_info = text_info.split("|")

    param = {"id": express_info[0].strip(), "validateCode": express_info[1].strip(), "status": "IN_STORE"}
    expresses = ExpressDao.get_express_by_id_and_validate(param)
    pre_take_express(expresses)


def pre_take_express(expresses):
    if len(expresses) != 1:
        express_signal_handler.customer_take_express_signal.emit("Error")
        return
    express = expresses[0]

    take_express(express)
    '''
    if express["overdueTime"] > ClientTools.now():
        take_express(express)
    else:
        pre_take_overdue_express(express)
    '''


def take_express(param, overdue=False):
    express = {"takeTime": ClientTools.now(), "status": "CUSTOMER_TAKEN", "syncFlag": 0,
               "version": param["version"] + 1, "id": param["id"], "staffTakenUser_id": None,
               "lastModifiedTime": ClientTools.now()}

    ExpressDao.take_express(express)
    mouth_param = box.service.BoxService.get_mouth(express)
    box.service.BoxService.free_mouth(mouth_param)
    box.service.BoxService.open_mouth(mouth_param["id"])

    express_signal_handler.customer_take_express_signal.emit("Success")
    if overdue:
        record_list = ExpressDao.get_record({"express_id": express["id"]})
        if len(record_list) == 1:
            record = record_list[0]
            record_param = {"id": record["id"], "createTime": record["createTime"], "amount": record["amount"]}
            express["transactionRecords"] = [record_param, ]
    result, status_code = HttpClient.post_message("express/customerTakeExpress", express)
    if status_code == 200:
        express["lastModifiedTime"] = ClientTools.now()
        ExpressDao.mark_sync_success(express)


overdue_express = None

'''
def pre_take_overdue_express(express_param):
    global overdue_cost, overdue_express, paid_amount
    overdue_express = express_param
    mouth_param = box.service.BoxService.get_mouth(express_param)
    time_span = ClientTools.now() - express_param["overdueTime"]
    day_span = math.ceil(time_span / 1000.0 / 60.0 / 60.0 / 24.0)
    overdue_cost = day_span * mouth_param["overduePrice"]
    record_param = {"express_id": overdue_express["id"]}
    record_list = ExpressDao.get_record(record_param)
    if len(record_list) == 0:
        record_param = {"id": ClientTools.get_uuid(), "paymentType": "CASH", "transactionType": "PAYMENT_FOR_OVERDUE",
                        "amount": 0, "express_id": overdue_express["id"], "createTime": ClientTools.now()}
        ExpressDao.save_record(record_param)
        paid_amount = 0
    else:
        record = record_list[0]
        paid_amount = math.ceil(record["amount"] * -1)
    express_signal_handler.customer_take_express_signal.emit("Overdue")
'''

paid_amount = 0

coin_machine_connect_flag = False


def start_pay_cash_for_overdue_express():
    global coin_machine_connect_flag
    if not coin_machine_connect_flag:
        coin_machine_connect_flag = True
        CoinMachine.coin_machine_signal_handler.coin_result.connect(pay_cash_for_overdue_express)
        CoinMachine.start_get_coin()


def stop_pay_cash_for_overdue_express():
    global coin_machine_connect_flag
    if coin_machine_connect_flag:
        CoinMachine.coin_machine_signal_handler.coin_result.disconnect(pay_cash_for_overdue_express)
        coin_machine_connect_flag = False


def pay_cash_for_overdue_express(text):
    global overdue_cost, paid_amount, overdue_express
    if text == "False":
        CoinMachine.start_get_coin()
        return
    paid_amount += 100
    record = {"express_id": overdue_express["id"],
              "amount": paid_amount * -1}
    ExpressDao.update_recode(record)
    express_signal_handler.paid_amount_signal.emit(str(math.ceil(paid_amount / 100)))
    if paid_amount < overdue_cost:
        CoinMachine.start_get_coin()
    else:
        stop_pay_cash_for_overdue_express()
        take_express(overdue_express, overdue=True)


def take_overdue_express():
    pass


def get_overdue_cost():
    global overdue_cost
    express_signal_handler.overdue_cost_signal.emit(str(math.ceil(overdue_cost / 100)))


scanner_signal_connect_flag = False


def start_get_express_number_by_barcode():
    global scanner_signal_connect_flag
    if not scanner_signal_connect_flag:
        Scanner.scanner_signal_handler.barcode_result.connect(get_express_number_by_barcode)
        scanner_signal_connect_flag = True
    Scanner.start_get_text_info()


express_id = ""

imported_express = None


def get_express_number_by_barcode(text):
    global express_id, imported_express
    if text == "ERROR":
        return
    if text == "":
        return
    express_signal_handler.barcode_signal.emit(text)
    express_message, status_code = HttpClient.get_message("express/imported/" + text)
    if status_code == 200:
        imported_express = express_message
        express_id = imported_express["id"]
        express_signal_handler.phone_number_signal.emit(imported_express["takeUserPhoneNumber"])
    elif status_code == 404:
        express_signal_handler.imported_express_result_signal.emit("no_imported")
        imported_express = None
        express_id = ""
    else:
        express_signal_handler.imported_express_result_signal.emit("NoInterNet")
        imported_express = None
        express_id = ""


def stop_get_express_number_by_barcode():
    global scanner_signal_connect_flag
    if scanner_signal_connect_flag:
        Scanner.scanner_signal_handler.barcode_result.disconnect(get_express_number_by_barcode)
        scanner_signal_connect_flag = False
        Scanner.start_stop_scanner()


def start_get_imported_express(text):
    get_express_number_by_text(text)


def get_express_number_by_text(text):
    global express_id, imported_express
    express_message, status_code = HttpClient.get_message("express/imported/" + text)

    if status_code == 200:
        imported_express = express_message
        express_id = imported_express["id"]
        express_signal_handler.imported_express_result_signal.emit(imported_express["takeUserPhoneNumber"])
    elif status_code == 404:
        express_signal_handler.imported_express_result_signal.emit("no_imported")
        imported_express = None
        express_id = ""
    else:
        express_signal_handler.imported_express_result_signal.emit("NoInterNet")
        imported_express = None
        express_id = ""


express_number = ""


def set_express_number(express_number__):
    global express_number
    express_number = express_number__


phone_number = ""


def set_phone_number(phone_number__):
    global phone_number
    phone_number = phone_number__


def start_store_express():
    ClientTools.get_global_pool().apply_async(store_express)


def store_express():
    global express_number, express_id, imported_express, aID
    print('aID2:', aID)
    try:
        mouth_result = box.service.BoxService.mouth
        logger.debug(("mouth_result:", mouth_result))
        box_result = box.service.BoxService.get_box()

        if not box_result:
            express_signal_handler.store_express_signal.emit("Error")
            return
        express_param = {"expressNumber": aID, "expressType": "CUSTOMER_TO_CUSTOMER",
                         "status": "IN_STORE", "storeTime": ClientTools.now(), "syncFlag": 0,
                         "validateCode": random_validate(box_result["validateType"]),
                         "version": 0, "box_id": box_result["id"],
                         "mouth_id": mouth_result["id"], "operator_id": box_result["operator_id"],
                         "groupName": ClientTools.get_value("groupName", imported_express),
                         "payAmount": ClientTools.get_value("payAmount", imported_express),
                         "payType": ClientTools.get_value("payType", imported_express),
                         "order_id": ClientTools.get_value("order_id", imported_express),
                         "takeUser_id": ClientTools.get_value("id",
                                                              ClientTools.get_value("takeUser", imported_express))}

        logger.info(("express_id:", express_id))
        if express_id == "":
            express_param["id"] = ClientTools.get_uuid()
        elif express_id is None:
            express_param["id"] = ClientTools.get_uuid()
        else:
            express_param["id"] = express_id

        express_param["lastModifiedTime"] = ClientTools.now()
        logger.info("start wo creat databases info")

        ExpressDao.save_express(express_param)
        logger.info("creat databases success")
        mouth_param = {"id": mouth_result["id"], "express_id": express_param["id"], "status": "USED"}

        box.service.BoxService.use_mouth(mouth_param)
        express_param["box"] = {"id": express_param['box_id']}
        express_param.pop("box_id")
        express_param["mouth"] = {"id": express_param["mouth_id"]}
        express_param.pop("mouth_id")
        express_param["operator"] = {"id": express_param["operator_id"]}
        express_param.pop("operator_id")
        express_signal_handler.store_express_signal.emit("Success")
        express_id = None
        imported_express = None
        logger.info("start to store data into local database")
        message, status_code = HttpClient.post_message("express/storeExpressForCustomerToCustomer", express_param)
        if status_code == 200:
            express_param["lastModifiedTime"] = ClientTools.now()
            ExpressDao.mark_sync_success(express_param)
            logger.info("data update to servers success！")
    except Exception as e:
        logger.warn(("store_express error :", e))


def get_overdue_timestamp(box_result):
    start_time = datetime.datetime.now()
    pre_end_time = get_timestamp(start_time, box_result)
    if "holidayType" not in box_result.keys():
        return int(time.mktime(time.strptime(pre_end_time.strftime('%Y-%m-%d %H:%M:%S'), '%Y-%m-%d %H:%M:%S')) * 1000)
    else:
        overdue_timestamp = int(
            time.mktime(time.strptime(pre_end_time.strftime('%Y-%m-%d %H:%M:%S'), '%Y-%m-%d %H:%M:%S')) * 1000)
        holiday_info = ExpressDao.get_holiday_info({"holidayType": box_result["holidayType"]})
        if len(holiday_info) == 0:
            return overdue_timestamp
        else:
            for _holiday_info in holiday_info:
                if _holiday_info["startTime"] <= overdue_timestamp <= _holiday_info["endTime"]:
                    ho_start_time = datetime.datetime.utcfromtimestamp(_holiday_info["endTime"] / 1000)
                    ho_end_time = get_timestamp(ho_start_time, box_result, delay_day=_holiday_info["delayDay"])
                    end_time = ho_end_time
                    return int(
                        time.mktime(time.strptime(end_time.strftime('%Y-%m-%d %H:%M:%S'), '%Y-%m-%d %H:%M:%S')) * 1000)
                else:
                    continue
            end_time = pre_end_time
            return int(time.mktime(time.strptime(end_time.strftime('%Y-%m-%d %H:%M:%S'), '%Y-%m-%d %H:%M:%S')) * 1000)


def get_timestamp(start_time, box_result, delay_day=None):
    if delay_day is None:
        if box_result["overdueType"] == "HOUR":
            end_time = start_time + datetime.timedelta(hours=box_result["freeHours"])
        else:
            end_time = (start_time + datetime.timedelta(days=box_result["freeDays"])).replace(hour=23, minute=00,
                                                                                              second=00)
    else:
        if box_result["overdueType"] == "HOUR":
            end_time = start_time + datetime.timedelta(hours=box_result["freeHours"])
        else:
            end_time = (start_time + datetime.timedelta(days=delay_day)).replace(hour=23, minute=00, second=00)
    return end_time


def random_validate(validate_type):
    while True:
        if validate_type == "LETTER_AND_NUMBER_VALIDATE_CODE":
            chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
            validate_code = ''
            i = 0
            while i < 6:
                validate_code += random.choice(chars)
                i += 1
            if len(ExpressDao.get_express_by_validate({"validateCode": validate_code, "status": "IN_STORE"})) == 0:
                return validate_code
        else:
            return ""


customer_store_number = ""
customer_store_express = ""
bg_username = ""


def start_get_oacheck_info(text):
    global customer_store_number
    try:
        customer_store_number = text
        ClientTools.get_global_pool().apply_async(get_OANoCheck_info)
    except Exception as e:
        logger.warn(("start_get_oacheck_info:", e))


def start_set_username(text):
    global bg_username
    bg_username = text


def start_get_about_oainfo(text):
    global customer_store_number
    try:
        customer_store_number = text
        ClientTools.get_global_pool().apply_async(get_about_oainfo)
    except Exception as e:
        logger.warn(("start_get_about_info:", e))

aID = ''


def get_about_oainfo():
    # customer_store_number是oa单号
    global aID
    mouth_number = box.service.BoxService.last_mouth_number
    print('mouth_number', mouth_number)
    __user = {'username': bg_username.lower(), 'oaNumber': customer_store_number, 'mouthNumber': mouth_number}
    i = 1
    while i <= 15:
        message, status_code = HttpClient.post_message("genomics/mountCheck/", __user)
        aID = message['aID']
        print("aID:", aID)
        if status_code == 200:
            express_signal_handler.about_oainfo_express_signal.emit("Success")
            express_signal_handler.about_oainfo_express_message_signal.emit(message['msg'])
            break
        else:
            time.sleep(1)
            i += 1
    if i >= 15:
        message, status_code = HttpClient.get_message("genomics/mountCheck/" + customer_store_number)
        if status_code == 200:
            express_signal_handler.about_oainfo_express_signal.emit("Success")
            express_signal_handler.about_oainfo_express_message_signal.emit(message['msg'])
        else:
            express_signal_handler.about_oainfo_express_signal.emit("Faile")
            express_signal_handler.about_oainfo_express_message_signal.emit(message['msg'])


'''
    message, status_code = HttpClient.get_message("genomics/mountCheck/" + customer_store_number)

    if status_code == 200:
        # express_signal_handler.about_oainfo_express_signal.emit(str(json.dumps(customer_store_express)))
        express_signal_handler.about_oainfo_express_signal.emit("Success")
    else:
        time.sleep(2)
        message, status_code = HttpClient.get_message("genomics/mountCheck/" + customer_store_number)
        if status_code == 200:
            express_signal_handler.about_oainfo_express_signal.emit("Success")
        else:
            time.sleep(4)
            message, status_code = HttpClient.get_message("genomics/mountCheck/" + customer_store_number)
            if status_code == 200:
                express_signal_handler.about_oainfo_express_signal.emit("Success")
            else:
                time.sleep(2)
                message, status_code = HttpClient.get_message("genomics/mountCheck/" + customer_store_number)
                if status_code == 200:
                    express_signal_handler.about_oainfo_express_signal.emit("Success")
                else:
                    express_signal_handler.about_oainfo_express_signal.emit("False")
'''


def get_OANoCheck_info():
    global customer_store_number
    __user = {'username': bg_username.lower(), 'oaNumber': customer_store_number}
    try:
        print(__user)
        message, status_code = HttpClient.post_message("genomics/OANoCheck/", __user)
        print('status_code:', status_code)
        print('message:', message)
        if status_code == 200:
            if message['status'] == '0':
                express_signal_handler.customer_store_express_signal.emit("Success")
            else:
                express_signal_handler.customer_store_express_signal.emit("False")
                # 回显失败原因
                express_signal_handler.check_oa1_result_signal.emit(message['msg'])
        else:
            express_signal_handler.customer_store_express_signal.emit("Net_error")
    except Exception as e:
        logger.warn(("start_get_OANoCheck_info:", e))


customer_reject_number = ""
customer_reject_express = ""


def start_get_customer_reject_express_info(text):
    global customer_reject_number
    customer_reject_number = text
    ClientTools.get_global_pool().apply_async(get_customer_reject_express_info)


def get_customer_reject_express_info():
    global customer_reject_number, customer_reject_express
    message, status_code = HttpClient.get_message("express/rejectExpress/" + customer_reject_number)
    if status_code == 200:
        customer_reject_express = message
        express_signal_handler.customer_reject_express_signal.emit(str(json.dumps(customer_reject_express)))
    else:
        express_signal_handler.customer_reject_express_signal.emit("False")


customer_scanner_signal_connect_flag = False

'''
def start_customer_scan_qr_code():
    global customer_scanner_signal_connect_flag
    if not customer_scanner_signal_connect_flag:
        Scanner.scanner_signal_handler.barcode_result.connect(customer_scan_qr_code)
        customer_scanner_signal_connect_flag = True
    Scanner.start_get_text_info()


def stop_customer_scan_qr_code():
    global customer_scanner_signal_connect_flag
    if not customer_scanner_signal_connect_flag:
        return
    customer_scanner_signal_connect_flag = False
    Scanner.scanner_signal_handler.barcode_result.disconnect(customer_scan_qr_code)
    Scanner.start_stop_scanner()


def customer_scan_qr_code(text):
    global customer_scanner_signal_connect_flag, customer_store_number
    if text == "ERROR":
        return
    if text == "":
        customer_scanner_signal_connect_flag = False
        return
    express_signal_handler.barcode_signal.emit(text)
    customer_store_number = text
    ClientTools.get_global_pool().apply_async(get_customer_store_express_info)
    customer_scanner_signal_connect_flag = False
'''


def start_load_courier_overdue_express_count():
    ClientTools.get_global_pool().apply_async(load_courier_overdue_express_count)


def load_courier_overdue_express_count():
    __user = user.service.UserService.get_user()
    param = {"status": "IN_STORE", "overdueTime": ClientTools.now(), "logisticsCompany_id": __user["company"]["id"],
             "expressType": "COURIER_STORE"}

    count_list = ExpressDao.get_overdue_express_count_by_logistics_id(param)
    express_signal_handler.overdue_express_count_signal.emit(count_list[0]["count"])


def start_courier_load_overdue_express_list(page):
    ClientTools.get_global_pool().apply_async(courier_load_overdue_express, (page,))
    express_signal_handler.load_express_list_signal.emit("Success")


def courier_load_overdue_express(page):
    __user = user.service.UserService.get_user()
    param = {"status": "IN_STORE", "overdueTime": ClientTools.now(), "logisticsCompany_id": __user["company"]["id"],
             "expressType": "COURIER_STORE",
             "startLine": (int(page) - 1) * 5}
    overdue_express_list_ = ExpressDao.get_overdue_express_by_logistics_id(param)
    for overdue_express_ in overdue_express_list_:
        overdue_express_["mouth"] = box.service.BoxService.get_mouth(overdue_express_)
    express_signal_handler.overdue_express_list_signal.emit(json.dumps(overdue_express_list_))


def start_load_manager_overdue_express_count():
    ClientTools.get_global_pool().apply_async(load_manager_overdue_express_count)


def load_manager_overdue_express_count():
    param = {"status": "IN_STORE", "overdueTime": ClientTools.now(), "expressType": "COURIER_STORE"}
    count_list = ExpressDao.get_overdue_express_count_by_manager(param)
    express_signal_handler.overdue_express_count_signal.emit(count_list[0]["count"])


def start_manager_load_overdue_express_list(page):
    ClientTools.get_global_pool().apply_async(manager_load_overdue_express, (page,))
    express_signal_handler.load_express_list_signal.emit("Success")


def manager_load_overdue_express(page):
    param = {"status": "IN_STORE", "overdueTime": ClientTools.now(), "expressType": "COURIER_STORE",
             "startLine": (int(page) - 1) * 5}
    overdue_express_list_ = ExpressDao.get_overdue_express_by_manager(param)
    for overdue_express_ in overdue_express_list_:
        overdue_express_["mouth"] = box.service.BoxService.get_mouth(overdue_express_)
    express_signal_handler.overdue_express_list_signal.emit(json.dumps(overdue_express_list_))


def start_staff_take_all_overdue_express():
    ClientTools.get_global_pool().apply_async(staff_take_all_overdue_express())


def staff_take_all_overdue_express():
    __user = user.service.UserService.get_user()
    __express_list = []
    if __user['role'] == "LOGISTICS_COMPANY_USER" or __user['role'] == "LOGISTICS_COMPANY_ADMIN":
        __param = {"status": "IN_STORE", "overdueTime": ClientTools.now(), "expressType": "COURIER_STORE",
                   "logisticsCompany_id": __user["company"]["id"]}
        __express_list = ExpressDao.get_all_overdue_express_by_logistics_id(__param)

    elif __user['role'] == "OPERATOR_USER" or __user['role'] == "OPERATOR_ADMIN":
        __param = {"status": "IN_STORE", "overdueTime": ClientTools.now(), "expressType": "COURIER_STORE"}
        __express_list = ExpressDao.get_all_overdue_express_by_manager(__param)
    logger.info("overdue_express_count:" + str(len(__express_list)))
    if len(__express_list) == 0:
        express_signal_handler.staff_take_overdue_express_signal.emit("None")
        return
    for __express in __express_list:
        staff_take_overdue_express(__user, __express)
    express_signal_handler.staff_take_overdue_express_signal.emit("Success")


def start_staff_take_overdue_express_list(express_id_list):
    ClientTools.get_global_pool().apply_async(staff_take_overdue_express_list, (express_id_list,))


def staff_take_overdue_express_list(express_id_list):
    logger.info(("express_id_list:", express_id_list))
    __express_list = json.loads(express_id_list)
    if len(__express_list) == 0:
        express_signal_handler.staff_take_overdue_express_signal.emit("None")
        return
    __user = user.service.UserService.get_user()
    for __express in __express_list:
        express_result_list = ExpressDao.get_express_by_id({"id": __express})
        express = express_result_list[0]
        staff_take_overdue_express(__user, express)
    express_signal_handler.staff_take_overdue_express_signal.emit("Success")


def staff_take_overdue_express(__user, express):
    express["takeTime"] = ClientTools.now()
    if __user['role'] == "LOGISTICS_COMPANY_USER" or __user['role'] == "LOGISTICS_COMPANY_ADMIN":
        express["status"] = "COURIER_TAKEN"
    if __user['role'] == "OPERATOR_USER" or __user['role'] == "OPERATOR_ADMIN":
        express["status"] = "OPERATOR_TAKEN"
    express["staffTakenUser_id"] = __user["id"]
    express["version"] += 1
    express["syncFlag"] = 0
    express["lastModifiedTime"] = ClientTools.now()
    ExpressDao.take_express(express)
    box.service.BoxService.free_mouth({"id": express["mouth_id"]})
    box.service.BoxService.open_mouth(express["mouth_id"])
    express["staffTakenUser"] = {"id": express["staffTakenUser_id"]}
    ClientTools.get_global_pool().apply_async(sync_staff_take_overdue_express, (express,))


def sync_staff_take_overdue_express(express):
    message, status_code = HttpClient.post_message("express/staffTakeOverdueExpress", express)
    if status_code == 200:
        express["lastModifiedTime"] = ClientTools.now()
        ExpressDao.mark_sync_success(express)


def get_scan_not_sync_express_list():
    return ExpressDao.get_not_sync_express_list({"syncFlag": 0})


def mark_sync_success(express_):
    express_["lastModifiedTime"] = ClientTools.now()
    ExpressDao.mark_sync_success(express_)


calculate_customer_express_cost_flag = False


def start_calculate_customer_express_cost():
    global calculate_customer_express_cost_flag
    if not calculate_customer_express_cost_flag:
        calculate_customer_express_cost_flag = True
        WeighingMachine.weighing_machine_signal_handler.weight_signal.connect(calculate_customer_express_cost)
        WeighingMachine.start_get_weight()


def stop_calculate_customer_express_cost():
    global calculate_customer_express_cost_flag
    if calculate_customer_express_cost_flag:
        calculate_customer_express_cost_flag = False


customer_express_weight = 0
customer_express_cost = 0


def calculate_customer_express_cost(weight):
    global calculate_customer_express_cost_flag, customer_store_express, express_signal_handler, \
        customer_express_weight, customer_express_cost
    if not calculate_customer_express_cost_flag:
        return
    customer_express_weight = weight
    range_price_ = customer_store_express
    cost = 0
    cost += range_price_["firstPrice"]
    continued_weight = weight - range_price_["firstHeavy"]
    if continued_weight < 0:
        continued_weight = 0
    cost += math.ceil(continued_weight / range_price_["continuedHeavy"]) * range_price_["continuedPrice"]
    cost_result_ = {"heavy": weight, "cost": cost}
    customer_express_cost = cost
    express_signal_handler.customer_store_express_cost_signal.emit(json.dumps(cost_result_))


pay_cash_for_customer_express_flag = False


def start_pay_cash_for_customer_express():
    global pay_cash_for_customer_express_flag
    if not pay_cash_for_customer_express_flag:
        pay_cash_for_customer_express_flag = True
        pre_pay_cash_for_customer_express()


def stop_pay_cash_for_customer_express():
    global pay_cash_for_customer_express_flag
    if pay_cash_for_customer_express_flag:
        CoinMachine.coin_machine_signal_handler.coin_result.disconnect(pay_cash_for_customer_express)
        pay_cash_for_customer_express_flag = False


def start_pull_pre_pay_cash_for_customer_express(express_cost):
    global customer_express_cost, pay_cash_for_customer_express_flag
    customer_express_cost = express_cost


def pre_pay_cash_for_customer_express():
    global customer_express_cost, customer_paid_amount, customer_store_express
    record_list = ExpressDao.get_record({"express_id": customer_store_express["id"]})
    CoinMachine.coin_machine_signal_handler.coin_result.connect(pay_cash_for_customer_express)
    if len(record_list) == 0:
        record_param = {"id": ClientTools.get_uuid(), "paymentType": "CASH",
                        "transactionType": "PAYMENT_FOR_SEND_EXPRESS",
                        "amount": 0, "express_id": customer_store_express["id"], "createTime": ClientTools.now()}
        ExpressDao.save_record(record_param)
        customer_paid_amount = 0
    else:
        record = record_list[0]
        customer_paid_amount = math.ceil(record["amount"] * -1)
        express_signal_handler.paid_amount_signal.emit(str(math.ceil(customer_paid_amount / 100)))
        if customer_paid_amount == customer_express_cost:
            return
    CoinMachine.start_get_coin()


customer_paid_amount = 0


def pay_cash_for_customer_express(text):
    global customer_express_cost, customer_paid_amount, customer_store_express
    if text == "False":
        CoinMachine.start_get_coin()
        return
    customer_paid_amount += 100
    record = {"express_id": customer_store_express["id"],
              "amount": customer_paid_amount * -1}
    ExpressDao.update_recode(record)
    express_signal_handler.paid_amount_signal.emit(str(math.ceil(customer_paid_amount / 100)))
    if customer_paid_amount < customer_express_cost:
        CoinMachine.start_get_coin()
    else:
        stop_pay_cash_for_customer_express()


calculate_customer_reject_express_cost_flag = False


def start_calculate_customer_reject_express_cost():
    global calculate_customer_reject_express_cost_flag
    if not calculate_customer_reject_express_cost_flag:
        calculate_customer_reject_express_cost_flag = True
        WeighingMachine.weighing_machine_signal_handler.weight_signal.connect(calculate_customer_reject_express_cost)
        WeighingMachine.start_get_weight()


def stop_calculate_customer_reject_express_cost():
    global calculate_customer_reject_express_cost_flag
    if calculate_customer_reject_express_cost_flag:
        calculate_customer_reject_express_cost_flag = False


customer_reject_express_weight = 0
customer_reject_express_cost = 0


def calculate_customer_reject_express_cost(weight):
    global calculate_customer_reject_express_cost_flag, customer_reject_express, express_signal_handler, \
        customer_reject_express_weight, customer_reject_express_cost
    if not calculate_customer_reject_express_cost_flag:
        return
    customer_reject_express_weight = weight
    range_price_ = customer_reject_express
    cost = 0
    cost += range_price_["firstPrice"]
    continued_weight = weight - range_price_["firstHeavy"]
    if continued_weight < 0:
        continued_weight = 0
    cost += math.ceil(continued_weight / range_price_["continuedHeavy"]) * range_price_["continuedPrice"]
    cost_result_ = {"heavy": weight, "cost": cost}
    customer_reject_express_cost = cost
    express_signal_handler.customer_store_express_cost_signal.emit(json.dumps(cost_result_))


pay_cash_for_customer_reject_express_flag = False


def start_pay_cash_for_customer_reject_express():
    global pay_cash_for_customer_reject_express_flag
    if not pay_cash_for_customer_reject_express_flag:
        pay_cash_for_customer_reject_express_flag = True
        pre_pay_cash_for_customer_reject_express()


def stop_pay_cash_for_customer_reject_express():
    global pay_cash_for_customer_reject_express_flag
    if pay_cash_for_customer_reject_express_flag:
        CoinMachine.coin_machine_signal_handler.coin_result.disconnect(pay_cash_for_customer_reject_express)
        pay_cash_for_customer_reject_express_flag = False


def start_pull_pre_pay_cash_for_customer_reject_express(express_cost):
    global customer_reject_express_cost, pay_cash_for_customer_reject_express_flag
    customer_reject_express_cost = express_cost


def pre_pay_cash_for_customer_reject_express():
    global customer_reject_express_cost, customer_paid_amount, customer_reject_express
    record_list = ExpressDao.get_record({"express_id": customer_reject_express["id"]})
    CoinMachine.coin_machine_signal_handler.coin_result.connect(pay_cash_for_customer_reject_express)
    if len(record_list) == 0:
        record_param = {"id": ClientTools.get_uuid(), "paymentType": "CASH",
                        "transactionType": "PAYMENT_FOR_SEND_EXPRESS",
                        "amount": 0, "express_id": customer_reject_express["id"], "createTime": ClientTools.now()}
        ExpressDao.save_record(record_param)
        customer_paid_amount = 0
    else:
        record = record_list[0]
        customer_paid_amount = math.ceil(record["amount"] * -1)
        express_signal_handler.paid_amount_signal.emit(str(math.ceil(customer_paid_amount / 100)))
        if customer_paid_amount == customer_reject_express_cost:
            return
    CoinMachine.start_get_coin()


def pay_cash_for_customer_reject_express(text):
    global customer_reject_express_cost, customer_paid_amount, customer_reject_express
    if text == "False":
        CoinMachine.start_get_coin()
        return
    customer_paid_amount += 100
    record = {"express_id": customer_reject_express["id"],
              "amount": customer_paid_amount * -1}
    ExpressDao.update_recode(record)
    express_signal_handler.paid_amount_signal.emit(str(math.ceil(customer_paid_amount / 100)))
    if customer_paid_amount < customer_reject_express_cost:
        CoinMachine.start_get_coin()
    else:
        stop_calculate_customer_reject_express_cost()


store_customer_express_flag = False


def start_store_customer_express():
    global store_customer_express_flag
    if not store_customer_express_flag:
        store_customer_express_flag = True
        ClientTools.get_global_pool().apply_async(store_customer_express)


def store_customer_express():
    global store_customer_express_flag, customer_store_express, customer_express_weight, customer_store_number
    box_result = box.service.BoxService.get_box()
    try:

        customer_store_express["box_id"] = box.service.BoxService.get_box()["id"]
        customer_store_express["id"] = ClientTools.get_uuid()
        customer_store_express["logisticsCompany_id"] = None
        customer_store_express["customerStoreNumber"] = customer_store_number
        customer_store_express["expressType"] = "CUSTOMER_STORE"

        mouth_result = box.service.BoxService.mouth

        mouth_param = {"id": mouth_result["id"], "express_id": customer_store_express["id"], "status": "USED"}

        box.service.BoxService.use_mouth(mouth_param)

        customer_store_express["mouth"] = mouth_result
        customer_store_express["mouth_id"] = mouth_result["id"]
        customer_store_express["operator_id"] = box.service.BoxService.get_box()["operator_id"]
        customer_store_express["storeUser_id"] = ClientTools.get_value("id", ClientTools.get_value("storeUser",
                                                                                                   customer_store_express,
                                                                                                   {}))
        customer_store_express["weight"] = customer_express_weight
        customer_store_express["storeTime"] = ClientTools.now()
        customer_store_express["chargeType"] = None
        customer_store_express["lastModifiedTime"] = ClientTools.now()
        customer_store_express["recipientName"] = None
        customer_store_express["weight"] = None
        customer_store_express["recipientUserPhoneNumber"] = None
        customer_store_express["validateCode"] = random_validate(box_result["validateType"])
        ExpressDao.save_customer_express(customer_store_express)

        express_signal_handler.store_customer_express_result_signal.emit("Success")

        record_list = ExpressDao.get_record({"express_id": customer_store_express["id"]})
        if len(record_list) == 1:
            record = record_list[0]
            record_param = {"id": record["id"], "createTime": record["createTime"], "amount": record["amount"]}
            customer_store_express["transactionRecords"] = [record_param, ]

        customer_store_express["box"] = {"id": customer_store_express["box_id"]}
        message, status_code = HttpClient.post_message("express/customerStoreExpress", customer_store_express)
        if status_code == 200:
            customer_store_express["lastModifiedTime"] = ClientTools.now()
            ExpressDao.mark_sync_success(customer_store_express)
        store_customer_express_flag = False
    except Exception as e:
        logger.warn(("store_customer_express error :", e))


store_customer_reject_express_flag = False


def start_store_customer_reject_express():
    global store_customer_reject_express_flag
    if not store_customer_reject_express_flag:
        store_customer_reject_express_flag = True
        ClientTools.get_global_pool().apply_async(store_customer_reject_express)


def store_customer_reject_express():
    global store_customer_reject_express_flag, customer_reject_express, customer_reject_express_weight
    customer_reject_express["box_id"] = box.service.BoxService.get_box()["id"]
    customer_reject_express["logisticsCompany_id"] = customer_reject_express["logisticsCompany"]["id"]
    mouth_result = box.service.BoxService.mouth

    mouth_param = {"id": mouth_result["id"], "express_id": customer_reject_express["id"], "status": "USED"}
    box.service.BoxService.use_mouth(mouth_param)

    customer_reject_express["mouth"] = mouth_result
    customer_reject_express["mouth_id"] = mouth_result["id"]
    customer_reject_express["operator_id"] = box.service.BoxService.get_box()["operator_id"]
    customer_reject_express["storeUser_id"] = ClientTools.get_value("id", ClientTools.get_value("storeUser",
                                                                                                customer_reject_express,
                                                                                                {}))
    customer_reject_express["weight"] = customer_reject_express_weight
    customer_reject_express["endAddress"] = ClientTools.get_value("endAddress", customer_reject_express, None)
    customer_reject_express["startAddress"] = ClientTools.get_value("startAddress", customer_reject_express, None)
    customer_reject_express["recipientName"] = ClientTools.get_value("recipientName", customer_reject_express, None)
    customer_reject_express["recipientUserPhoneNumber"] = ClientTools.get_value("recipientUserPhoneNumber",
                                                                                customer_reject_express, None)
    customer_reject_express["storeTime"] = ClientTools.now()
    customer_reject_express["chargeType"] = customer_reject_express["chargeType"]
    customer_reject_express["lastModifiedTime"] = ClientTools.now()
    ExpressDao.save_customer_express(customer_reject_express)

    express_signal_handler.store_customer_express_result_signal.emit("Success")

    record_list = ExpressDao.get_record({"express_id": customer_reject_express["id"]})
    if len(record_list) == 1:
        record = record_list[0]
        record_param = {"id": record["id"], "createTime": record["createTime"], "amount": record["amount"]}
        customer_reject_express["transactionRecords"] = [record_param, ]

    customer_reject_express["box"] = {"id": customer_reject_express['box_id']}
    message, status_code = HttpClient.post_message("express/customerRejectExpress", customer_reject_express)
    if status_code == 200:
        customer_reject_express["lastModifiedTime"] = ClientTools.now()
        ExpressDao.mark_sync_success(customer_reject_express)
    store_customer_reject_express_flag = False


def start_get_customer_express_cost():
    ClientTools.get_global_pool().apply_async(get_customer_express_cost)


def get_customer_express_cost():
    global customer_express_cost
    express_signal_handler.customer_express_cost_insert_coin_signal.emit(str(math.ceil(customer_express_cost / 100)))


def start_get_customer_reject_express_cost():
    ClientTools.get_global_pool().apply_async(get_customer_reject_express_cost)


def get_customer_reject_express_cost():
    global customer_reject_express_cost
    express_signal_handler.customer_express_cost_insert_coin_signal.emit(
        str(math.ceil(customer_reject_express_cost / 100)))


def get_scan_sync_express_transaction_record(param):
    return ExpressDao.get_record(param)


def start_load_customer_send_express_count():
    ClientTools.get_global_pool().apply_async(load_customer_send_express_count)


def load_customer_send_express_count():
    __user = user.service.UserService.get_user()
    if __user['role'] == "LOGISTICS_COMPANY_USER" or __user['role'] == "LOGISTICS_COMPANY_ADMIN":
        param = {"status": "IN_STORE", "expressType": "CUSTOMER_STORE", "logisticsCompany_id": __user["company"]["id"]}
        count_list = ExpressDao.get_send_express_count_by_logistics_id(param)
        express_signal_handler.send_express_count_signal.emit(count_list[0]["count"])
    elif __user['role'] == "OPERATOR_USER" or __user['role'] == "OPERATOR_ADMIN":
        param = {"status": "IN_STORE", "expressType": "CUSTOMER_STORE"}
        count_list = ExpressDao.get_send_express_count_by_operator(param)
        express_signal_handler.send_express_count_signal.emit(count_list[0]["count"])


def start_load_customer_reject_express_count():
    ClientTools.get_global_pool().apply_async(load_customer_reject_express_count)


def load_customer_reject_express_count():
    __user = user.service.UserService.get_user()
    if __user['role'] == "LOGISTICS_COMPANY_USER" or __user['role'] == "LOGISTICS_COMPANY_ADMIN":
        param = {"status": "IN_STORE", "expressType": "CUSTOMER_REJECT", "logisticsCompany_id": __user["company"]["id"]}
        count_list = ExpressDao.get_send_express_count_by_logistics_id(param)
        express_signal_handler.send_express_count_signal.emit(count_list[0]["count"])
    elif __user['role'] == "OPERATOR_USER" or __user['role'] == "OPERATOR_ADMIN":
        param = {"status": "IN_STORE", "expressType": "CUSTOMER_REJECT"}
        count_list = ExpressDao.get_send_express_count_by_operator(param)
        express_signal_handler.send_express_count_signal.emit(count_list[0]["count"])


def get_send_amount(express__: object) -> object:
    return ExpressDao.get_mouth(express__)


def start_customer_load_send_express_list(page):
    print(page)
    ClientTools.get_global_pool().apply_async(customer_load_send_express, (page,))
    express_signal_handler.load_express_list_signal.emit("Success")


def customer_load_send_express(page):
    __user = user.service.UserService.get_user()
    logger.debug("customer_load_send_express __user is : ", __user)
    send_express_list_ = []
    if __user['role'] == "LOGISTICS_COMPANY_USER" or __user['role'] == "LOGISTICS_COMPANY_ADMIN":
        param = {"status": "IN_STORE", "expressType": "CUSTOMER_STORE",
                 "logisticsCompany_id": __user["company"]["id"], "startLine": (int(page) - 1) * 5}
        send_express_list_ = ExpressDao.get_send_express_by_logistics_id(param)
    elif __user['role'] == "OPERATOR_USER" or __user['role'] == "OPERATOR_ADMIN":
        param = {"status": "IN_STORE", "expressType": "CUSTOMER_STORE", "startLine": (int(page) - 1) * 5}
        send_express_list_ = ExpressDao.get_send_express_by_operator(param)
    for send_express_ in send_express_list_:
        send_express_["mouth"] = box.service.BoxService.get_mouth(send_express_)
        send_express_["amount"] = get_send_amount(send_express_)
    express_signal_handler.send_express_list_signal.emit(json.dumps(send_express_list_))


'''
def start_customer_load_reject_express_list(page):
    ClientTools.get_global_pool().apply_async(customer_load_reject_express, (page,))
    express_signal_handler.load_express_list_signal.emit("Success")


def customer_load_reject_express(page):
    __user = user.service.UserService.get_user()
    logger.debug("customer_load_reject_express __user is : ", __user)
    send_express_list_ = []
    if __user['role'] == "LOGISTICS_COMPANY_USER" or __user['role'] == "LOGISTICS_COMPANY_ADMIN":
        param = {"status": "IN_STORE", "expressType": "CUSTOMER_REJECT",
                 "logisticsCompany_id": __user["company"]["id"], "startLine": (int(page) - 1) * 5}
        send_express_list_ = ExpressDao.get_send_express_by_logistics_id(param)
    elif __user['role'] == "OPERATOR_USER" or __user['role'] == "OPERATOR_ADMIN":
        param = {"status": "IN_STORE", "expressType": "CUSTOMER_REJECT", "startLine": (int(page) - 1) * 5}
        send_express_list_ = ExpressDao.get_send_express_by_operator(param)
    for send_express_ in send_express_list_:
        send_express_["mouth"] = box.service.BoxService.get_mouth(send_express_)
        send_express_["amount"] = get_send_amount(send_express_)
        send_express_["electronicCommerce"] = company.repository.CompanyDao.get_company_by_id(
            {"id": send_express_["electronicCommerce_id"]})[0]
    express_signal_handler.reject_express_list_signal.emit(json.dumps(send_express_list_))
'''


def start_staff_take_all_send_express():
    ClientTools.get_global_pool().apply_async(staff_take_all_send_express)


def staff_take_all_send_express():
    __user = user.service.UserService.get_user()
    __express_list = []
    if __user['role'] == "LOGISTICS_COMPANY_USER" or __user['role'] == "LOGISTICS_COMPANY_ADMIN":
        __param = {"status": "IN_STORE", "expressType": "CUSTOMER_STORE",
                   "logisticsCompany_id": __user["company"]["id"]}
        __express_list = ExpressDao.get_all_send_express_by_logistics_id(__param)

    elif __user['role'] == "OPERATOR_USER" or __user['role'] == "OPERATOR_ADMIN":
        __param = {"status": "IN_STORE", "expressType": "CUSTOMER_STORE", "overdueTime": ClientTools.now()}
        __express_list = ExpressDao.get_all_send_express_by_manager(__param)
    logger.info("send_express_count:" + str(len(__express_list)))
    if len(__express_list) == 0:
        express_signal_handler.staff_take_send_express_signal.emit("None")
        return
    for __express in __express_list:
        staff_take_send_express(__user, __express)
    express_signal_handler.staff_take_send_express_signal.emit("Success")


def start_staff_take_send_express_list(send_express_id_list):
    ClientTools.get_global_pool().apply_async(staff_take_send_express_list, (send_express_id_list,))


def staff_take_send_express_list(send_express_id_list):
    logger.info(("express_id_list:", send_express_id_list))
    __express_list = json.loads(send_express_id_list)
    if len(__express_list) == 0:
        express_signal_handler.staff_take_send_express_signal.emit("None")
        return
    __user = user.service.UserService.get_user()
    for __express in __express_list:
        express_result_list = ExpressDao.get_express_by_id({"id": __express})
        express = express_result_list[0]
        staff_take_send_express(__user, express)
    express_signal_handler.staff_take_send_express_signal.emit("Success")


def staff_take_send_express(__user, express):
    express["takeTime"] = ClientTools.now()
    if __user['role'] == "LOGISTICS_COMPANY_USER" or __user['role'] == "LOGISTICS_COMPANY_ADMIN":
        express["status"] = "COURIER_TAKEN"
    if __user['role'] == "OPERATOR_USER" or __user['role'] == "OPERATOR_ADMIN":
        express["status"] = "OPERATOR_TAKEN"
    express["staffTakenUser_id"] = __user["id"]
    express["version"] += 1
    express["syncFlag"] = 0
    express["lastModifiedTime"] = ClientTools.now()
    ExpressDao.take_express(express)
    box.service.BoxService.free_mouth({"id": express["mouth_id"]})
    box.service.BoxService.open_mouth(express["mouth_id"])
    express["staffTakenUser"] = {"id": express["staffTakenUser_id"]}
    ClientTools.get_global_pool().apply_async(sync_staff_take_send_express, (express,))


def sync_staff_take_send_express(express):
    message, status_code = HttpClient.post_message("express/staffTakeUserSendExpress", express)
    if status_code == 200:
        express["lastModifiedTime"] = ClientTools.now()
        ExpressDao.mark_sync_success(express)


def start_staff_take_all_reject_express():
    ClientTools.get_global_pool().apply_async(staff_take_all_reject_express)


def staff_take_all_reject_express():
    __user = user.service.UserService.get_user()
    __express_list = []
    if __user['role'] == "LOGISTICS_COMPANY_USER" or __user['role'] == "LOGISTICS_COMPANY_ADMIN":
        __param = {"status": "IN_STORE", "expressType": "CUSTOMER_REJECT",
                   "logisticsCompany_id": __user["company"]["id"]}
        __express_list = ExpressDao.get_all_send_express_by_logistics_id(__param)

    elif __user['role'] == "OPERATOR_USER" or __user['role'] == "OPERATOR_ADMIN":
        __param = {"status": "IN_STORE", "expressType": "CUSTOMER_REJECT", "overdueTime": ClientTools.now()}
        __express_list = ExpressDao.get_all_send_express_by_manager(__param)
    logger.info("reject_express_count:" + str(len(__express_list)))
    if len(__express_list) == 0:
        express_signal_handler.staff_take_send_express_signal.emit("None")
        return
    for __express in __express_list:
        staff_take_reject_express(__user, __express)
    express_signal_handler.staff_take_send_express_signal.emit("Success")


def start_staff_take_reject_express_list(reject_express_id_list):
    ClientTools.get_global_pool().apply_async(staff_take_reject_express_list, (reject_express_id_list,))


def staff_take_reject_express_list(reject_express_id_list):
    logger.info(("express_id_list:", reject_express_id_list))
    __express_list = json.loads(reject_express_id_list)
    if len(__express_list) == 0:
        express_signal_handler.staff_take_send_express_signal.emit("None")
        return
    __user = user.service.UserService.get_user()
    for __express in __express_list:
        express_result_list = ExpressDao.get_express_by_id({"id": __express})
        express = express_result_list[0]
        staff_take_reject_express(__user, express)
    express_signal_handler.staff_take_send_express_signal.emit("Success")


def staff_take_reject_express(__user, express):
    express["takeTime"] = ClientTools.now()
    if __user['role'] == "LOGISTICS_COMPANY_USER" or __user['role'] == "LOGISTICS_COMPANY_ADMIN":
        express["status"] = "COURIER_TAKEN"
    if __user['role'] == "OPERATOR_USER" or __user['role'] == "OPERATOR_ADMIN":
        express["status"] = "OPERATOR_TAKEN"
    express["staffTakenUser_id"] = __user["id"]
    express["version"] += 1
    express["syncFlag"] = 0
    express["lastModifiedTime"] = ClientTools.now()
    ExpressDao.take_express(express)
    box.service.BoxService.free_mouth({"id": express["mouth_id"]})
    box.service.BoxService.open_mouth(express["mouth_id"])
    express["staffTakenUser"] = {"id": express["staffTakenUser_id"]}
    ClientTools.get_global_pool().apply_async(sync_staff_take_reject_express, (express,))


def sync_staff_take_reject_express(express):
    message, status_code = HttpClient.post_message("express/staffTakeUserRejectExpress", express)
    if status_code == 200:
        express["lastModifiedTime"] = ClientTools.now()
        ExpressDao.mark_sync_success(express)


def start_service_pull_store_express(express_massage, timestamp=0):
    logger.info(("Server_pull timestamp is ", timestamp))
    if ClientTools.now() - timestamp >= 30000:
        return
    service_pull_store_express(express_massage)


def service_pull_store_express(express_massage):
    logger.info(("service_pull_store_express_info:", express_massage))
    param = {"id": express_massage["mouth"]["box"]["id"], "deleteFlag": 0}
    pull_box_info = box.repository.BoxDao.get_box_by_box_id(param)
    if len(pull_box_info) != 1:
        logger.warn("bad box_id")
        return False
    check_free_mouth_param = {"id": express_massage["mouth"]["id"], "status": "ENABLE"}
    logger.debug("start BoxDao")
    pull_mouth_result = box.repository.BoxDao.get_free_mouth_by_id(check_free_mouth_param)
    if len(pull_mouth_result) != 1:
        logger.warn("no free mouth")
        return False
    box.service.BoxService.pull_open_mouth(express_massage["mouth"]["id"])
    logger.debug("opened")
    express_param = {"id": express_massage["id"],
                     "expressNumber": express_massage["expressNumber"],
                     "expressType": express_massage["expressType"],
                     "overdueTime": express_massage["overdueTime"],
                     "status": express_massage["status"],
                     "storeTime": express_massage["storeTime"], "syncFlag": 1,
                     "takeUserPhoneNumber": express_massage["takeUserPhoneNumber"],
                     "validateCode": express_massage["validateCode"], "version": 0,
                     "box_id": express_massage["mouth"]["box"]["id"],
                     "logisticsCompany_id": express_massage["logisticsCompany"]["id"],
                     "mouth_id": express_massage["mouth"]["id"],
                     "operator_id": pull_box_info[0]["operator_id"],
                     "storeUser_id": express_massage["storeUser"]["id"],
                     "groupName": ClientTools.get_value("groupName", express_massage),
                     "lastModifiedTime": ClientTools.now()}
    logger.debug("express_param is :", express_param)
    ExpressDao.save_express(express_param)
    logger.debug("save express end")
    mouth_param = {"id": express_massage["mouth"]["id"], "express_id": express_massage["id"],
                   "status": "USED"}
    box.service.BoxService.use_mouth(mouth_param)
    logger.debug("use_mouth end")
    return True


def start_reset_express(express_massage):
    ClientTools.get_global_pool().apply_async(reset_express, (express_massage,))


def reset_express(express_massage):
    logger.info(("reset_express_info:", express_massage))
    param = {"id": express_massage["box"]["id"], "deleteFlag": 0}
    pull_box_info = box.repository.BoxDao.get_box_by_box_id(param)
    if len(pull_box_info) != 1:
        reset_express_post_message(express_massage["id"], "error box id", "ERROR")
        return
    express_info_list = ExpressDao.get_express_by_id({"id": express_massage["express"]["id"]})
    if len(express_info_list) != 1:
        reset_express_post_message(express_massage["id"], "no such express", "ERROR")
        return
    express_info = express_info_list[0]
    if express_massage["express"]["overdueTime"] <= express_massage["express"]["storeTime"]:
        reset_express_post_message(express_massage["id"], "overdueTime error", "ERROR")
        return
    express_param = {"id": express_massage["express"]["id"],
                     "overdueTime": express_massage["express"]["overdueTime"],
                     "status": express_massage["express"]["status"], "syncFlag": 1,
                     "takeUserPhoneNumber": express_massage["express"]["takeUserPhoneNumber"],
                     "validateCode": express_massage["express"]["validateCode"],
                     "version": express_info["version"] + 1}
    if express_info["status"] == "IN_STORE":
        logger.debug("the express in box")
        express_param["lastModifiedTime"] = ClientTools.now()
        ExpressDao.reset_express(express_param)
        reset_express_post_message(express_massage["id"], "IN_STORE express done", "SUCCESS")
        return
    if express_info["status"] == "CUSTOMER_TAKEN":
        logger.debug("the express taken by customer")
        mouth_info_list = box.repository.BoxDao.get_mouth_by_id({"id": express_massage["express"]["mouth"]["id"]})
        if len(mouth_info_list) != 1:
            reset_express_post_message(express_massage["id"], "mouth_id error", "ERROR")
            return
        mouth_info = mouth_info_list[0]
        if mouth_info["status"] != "ENABLE":
            reset_express_post_message(express_massage["id"], "mouth_status error", "ERROR")
            return
        if mouth_info["status"] == "ENABLE":
            mouth_param = {"status": "USED", "id": mouth_info["id"], "express_id": express_massage["express"]["id"]}
            box.repository.BoxDao.use_mouth(mouth_param)
            express_param["lastModifiedTime"] = ClientTools.now()
            ExpressDao.reset_express(express_param)
            reset_express_post_message(express_massage["id"], "CUSTOMER_TAKEN express done", "SUCCESS")
            return
    if express_info["status"] == "OPERATOR_TAKEN" or express_info["status"] == "COURIER_TAKEN":
        logger.debug("the express taken by staff")
        mouth_info_list = box.repository.BoxDao.get_mouth_by_id({"id": express_massage["express"]["mouth"]["id"]})
        if len(mouth_info_list) != 1:
            reset_express_post_message(express_massage["id"], "mouth_id error", "ERROR")
            return
        mouth_info = mouth_info_list[0]
        if mouth_info["status"] != "ENABLE":
            reset_express_post_message(express_massage["id"], "mouth_status error", "ERROR")
            return
        if mouth_info["status"] == "ENABLE":
            mouth_param = {"status": "USED", "id": mouth_info["id"], "express_id": express_massage["express"]["id"]}
            box.repository.BoxDao.use_mouth(mouth_param)
            express_param["lastModifiedTime"] = ClientTools.now()
            ExpressDao.reset_express(express_param)
            reset_express_post_message(express_massage["id"], "STAFF_TAKEN express done", "SUCCESS")
            return
    reset_express_post_message(express_massage["id"], "express status error", "ERROR")


def reset_express_post_message(task_id, result, reset_status):
    reset_express_result = {"id": task_id, "result": result, "statusType": reset_status}
    HttpClient.post_message("task/finish", reset_express_result)


electronic_commerce_reject_number = ""
electronic_reject_express = ""


def start_customer_reject_for_electronic_commerce(barcode):
    global electronic_commerce_reject_number
    electronic_commerce_reject_number = barcode
    ClientTools.get_global_pool().apply_async(customer_reject_for_electronic_commerce)


def customer_reject_for_electronic_commerce():
    global electronic_commerce_reject_number, electronic_reject_express, phone_number
    message, status_code = HttpClient.get_message("express/reject/checkRule/" + electronic_commerce_reject_number)
    if status_code == 200:
        electronic_reject_express = message
        electronic_reject_express["chargeType"] = "NOT_CHARGE"
        electronic_reject_express["package_id"] = electronic_commerce_reject_number
        express_signal_handler.customer_reject_express_signal.emit(str(json.dumps(electronic_reject_express)))
    else:
        express_signal_handler.customer_reject_express_signal.emit("False")


def start_get_electronic_commerce_reject_express():
    ClientTools.get_global_pool().apply_async(get_electronic_commerce_reject_express)


def get_electronic_commerce_reject_express():
    global electronic_reject_express, phone_number
    box_info = box.service.BoxService.get_box()
    electronic_reject_express["phone_number"] = phone_number
    electronic_reject_express["box_name"] = box_info["name"]
    express_signal_handler.reject_express_signal.emit(str(json.dumps(electronic_reject_express)))


store_customer_reject_for_electronic_commerce_flag = False


def start_store_customer_reject_for_electronic_commerce():
    global store_customer_reject_for_electronic_commerce_flag
    if not store_customer_reject_for_electronic_commerce_flag:
        store_customer_reject_for_electronic_commerce_flag = True
        ClientTools.get_global_pool().apply_async(store_customer_reject_for_electronic_commerce)


def store_customer_reject_for_electronic_commerce():
    global store_customer_reject_for_electronic_commerce_flag, electronic_reject_express, \
        electronic_commerce_reject_number, phone_number
    reject_express = dict()
    reject_express["id"] = ClientTools.get_uuid()
    reject_express["box_id"] = box.service.BoxService.get_box()["id"]
    reject_express["logisticsCompany_id"] = electronic_reject_express["logisticsCompany"]["id"]

    mouth_result = box.service.BoxService.mouth
    mouth_param = {"id": mouth_result["id"], "express_id": reject_express["id"], "status": "USED"}
    box.service.BoxService.use_mouth(mouth_param)
    reject_express["mouth"] = mouth_result
    reject_express["mouth_id"] = mouth_result["id"]

    reject_express["operator_id"] = box.service.BoxService.get_box()["operator_id"]
    reject_express["storeUser_id"] = ClientTools.get_value("id",
                                                           ClientTools.get_value("storeUser", electronic_reject_express,
                                                                                 {}))
    reject_express["endAddress"] = ClientTools.get_value("endAddress", electronic_reject_express, None)
    reject_express["startAddress"] = ClientTools.get_value("startAddress", electronic_reject_express, None)
    reject_express["recipientName"] = ClientTools.get_value("recipientName", electronic_reject_express, None)
    reject_express["weight"] = ClientTools.get_value("weight", electronic_reject_express, None)
    reject_express["storeUserPhoneNumber"] = ClientTools.get_value("storeUserPhoneNumber",
                                                                   electronic_reject_express, phone_number)
    reject_express["storeTime"] = ClientTools.now()
    reject_express["chargeType"] = electronic_reject_express["chargeType"]
    reject_express["customerStoreNumber"] = electronic_commerce_reject_number
    reject_express["expressType"] = "CUSTOMER_REJECT"

    reject_express["electronicCommerce_id"] = electronic_reject_express["electronicCommerce"]["id"]
    reject_express["lastModifiedTime"] = ClientTools.now()
    ExpressDao.save_customer_reject_express(reject_express)
    company_list = company.repository.CompanyDao.get_company_by_id(
        {"id": electronic_reject_express["electronicCommerce"]["id"]})

    electronic_commerce = {"id": electronic_reject_express["electronicCommerce"]["id"],
                           "companyType": "ELECTRONIC_COMMERCE",
                           "name": electronic_reject_express["electronicCommerce"]["name"], "deleteFlag": 0,
                           "parentCompany_id": ClientTools.get_value("parentCompany_id",
                                                                     electronic_reject_express["electronicCommerce"],
                                                                     None)}
    if len(company_list) == 0:
        company.repository.CompanyDao.insert_company(electronic_commerce)
    else:
        company.repository.CompanyDao.update_company(electronic_commerce)
    express_signal_handler.store_customer_express_result_signal.emit("Success")
    reject_express["box"] = {"id": box.service.BoxService.get_box()["id"]}
    reject_express["logisticsCompany"] = electronic_reject_express["logisticsCompany"]
    reject_express["electronicCommerce"] = electronic_reject_express["electronicCommerce"]
    message, status_code = HttpClient.post_message("express/rejectExpressNotImported", reject_express)
    if status_code == 200:
        reject_express["lastModifiedTime"] = ClientTools.now()
        ExpressDao.mark_sync_success(reject_express)
    store_customer_reject_for_electronic_commerce_flag = False


def start_customer_load_reject_express_list(page):
    return None
