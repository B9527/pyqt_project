import json
import logging
import time

from PyQt5.QtCore import QObject, pyqtSignal

import ClientTools
import Configurator
from box.repository import BoxDao
from company.repository import CompanyDao
from company.service import CompanyService
from database import ClientDatabase
from device import LockMachine
from device import UPSMachine
import express.service.ExpressService
import user.service.UserService
from network import HttpClient

__author__ = 'gaoyang'


class BoxSignalHandler(QObject):
    mouth_status_signal = pyqtSignal(str)
    init_client_signal = pyqtSignal(str)
    load_mouth_list_signal = pyqtSignal(str)
    manager_mouth_count_signal = pyqtSignal(int)
    mouth_list_signal = pyqtSignal(str)
    manager_set_mouth_signal = pyqtSignal(str)
    manager_open_mouth_by_id_signal = pyqtSignal(str)
    manager_open_all_mouth_signal = pyqtSignal(str)
    choose_mouth_signal = pyqtSignal(str)
    mouth_number_signal = pyqtSignal(str)
    free_mouth_num_signal = pyqtSignal(str)
    free_mouth_by_size_result = pyqtSignal(str)
    get_version_signal = pyqtSignal(str)
    manager_get_box_info_signal = pyqtSignal(str)


logger = logging.getLogger()
version = "1.26401.001.160811"
box_signal_handler = BoxSignalHandler()


def start_set_version():
    ClientTools.get_global_pool().apply_async(set_version)


def set_version():
    global version
    conf_version = Configurator.get_value("Version", "version")
    if conf_version is None:
        Configurator.set_value("Version", "version", version)
    elif conf_version == version:
        return
    else:
        Configurator.set_value("Version", "version", version)


def start_get_version():
    ClientTools.get_global_pool().apply_async(get_version)


def get_version():
    global version
    box_signal_handler.get_version_signal.emit(version)


def start_manager_get_box_info():
    ClientTools.get_global_pool().apply_async(manager_get_box_info)


def manager_get_box_info():
    box_info = get_box()
    box_info["operator_name"] = CompanyDao.get_company_by_id({"id": box_info["operator_id"]})[0]["name"]
    box_info["order_no"] = Configurator.get_value("ClientInfo", "OrderNo")
    box_info["token"] = Configurator.get_value("ClientInfo", "Token")
    # Scanner
    if Configurator.get_value("Scanner", "port"):
        box_info["scanner_port"] = Configurator.get_value("Scanner", "port")
    else:
        box_info["scanner_port"] = "None"
    # LockMachine
    if Configurator.get_value("LockMachine", "port"):
        box_info["lock_machine_port"] = Configurator.get_value("LockMachine", "port")
    else:
        box_info["lock_machine_port"] = "None"
    # UPS
    if Configurator.get_value("Ups", "port"):
        box_info["ups_port"] = Configurator.get_value("Ups", "port")
    else:
        box_info["ups_port"] = "None"

    box_signal_handler.manager_get_box_info_signal.emit(json.dumps(box_info))


def start_upgrade_init():
    ClientTools.get_global_pool().apply_async(upgrade_init)


def upgrade_init():
    try:
        init_flag = Configurator.get_value("Upgrade", "initFlag", default=0)
        if init_flag == "1":
            logger.debug("start to init client ")
            init_client()
            logger.debug("init_client finish ")
            Configurator.set_value("Upgrade", "initFlag", "0")
        else:
            logger.debug("init flag is 0")
    except Exception as e:
        logger.error(("upgrade_init ERROR :", e))


def start_init_client():
    ClientTools.get_global_pool().apply_async(init_client)


def init_client():
    try:
        message, status_code = HttpClient.get_message('box/init')
        if status_code != 200:
            return message['statusMessage']
        ClientDatabase.init_database()
        box_param = {'id': message['id'], 'name': message['name'], 'orderNo': message['orderNo'],
                     'validateType': message['validateType'], 'operator_id': message['operator']['id'],
                     'syncFlag': message['syncFlag'], 'currencyUnit': message['currencyUnit'],
                     "overdueType": message['overdueType'], "freeHours": ClientTools.get_value("freeHours", message),
                     "freeDays": ClientTools.get_value("freeDays", message),
                     "holidayType": ClientTools.get_value("holidayType", message, None),
                     "receiptNo": ClientTools.get_value("receiptNo", message, 0)}
        CompanyService.init_company(message['operator'])
        BoxDao.init_box(box_param)

        cabinets = message['cabinets']
        for cabinet in cabinets:
            BoxDao.init_cabinet(cabinet)
            mouths = cabinet['mouths']
            for m in mouths:
                __mouth = {'id': m['id'], 'deleteFlag': m['deleteFlag'], 'number': m['number'],
                           'usePrice': m['usePrice'],
                           'overduePrice': m['overduePrice'], 'status': m['status'], 'box_id': message['id'],
                           'cabinet_id': cabinet['id'], 'numberInCabinet': m['numberInCabinet'],
                           'syncFlag': m['syncFlag'], 'openOrder': ClientTools.get_value("openOrder", m)}
                if 'express' in m.keys():
                    __mouth['express_id'] = m['express']['id']
                    express.service.ExpressService.init_express(m['express'], __mouth, box_param)
                else:
                    __mouth['express_id'] = None
                __mouth['mouthType_id'] = m['mouthType']['id']
                mouth_type_param = m['mouthType']
                mouth_type = {'id': mouth_type_param['id'], 'name': mouth_type_param['name'],
                              'defaultUsePrice': mouth_type_param['defaultUsePrice'],
                              'defaultOverduePrice': mouth_type_param['defaultOverduePrice'],
                              'deleteFlag': mouth_type_param['deleteFlag']}
                BoxDao.init_mouth_type(mouth_type)
                BoxDao.init_mouth(__mouth)

        if "holidays" in message.keys():
            holidays = message["holidays"]
            for holiday in holidays:
                holiday_param = {'id': holiday['id'], 'startTime': holiday['startTime'], 'endTime': holiday['endTime'],
                                 'delayDay': holiday['delayDays'], 'holidayType': holiday['holidayType']}
                BoxDao.init_holiday(holiday_param)

        box_signal_handler.init_client_signal.emit("Success")
    except Exception as e:
        logger.error(("init_client ERROR :", e))
        box_signal_handler.init_client_signal.emit("ERROR")


def start_update_box(message_result):
    ClientTools.get_global_pool().apply_async(update_box, (message_result,))


def update_box(message_result):
    logger.info(("init_box_info:", message_result))
    try:
        box_param = {'id': message_result['box']['id'],
                     'name': message_result['box']['name'],
                     'orderNo': message_result['box']['orderNo'],
                     'validateType': message_result['box']['validateType'],
                     'currencyUnit': message_result['box']['currencyUnit'],
                     "overdueType": message_result['box']['overdueType'],
                     "freeHours": ClientTools.get_value("freeHours", message_result['box']),
                     "freeDays": ClientTools.get_value("freeDays", message_result['box']),
                     "holidayType": ClientTools.get_value("holidayType", message_result['box'])}
        BoxDao.update_box(box_param)
        box_post_message(message_result["id"], "update successful", "SUCCESS")
    except Exception as e:
        logger.warn(("update_box ERROR :", e))
        box_post_message(message_result["id"], "update error", "ERROR")


def start_free_mouth_by_size(mouth_size):
    free_mouth_by_size(mouth_size)


def free_mouth_by_size(mouth_size):
    mouth_type_param = {"name": mouth_size}
    mouth_type_list = BoxDao.get_mouth_type(mouth_type_param)
    if len(mouth_type_list) != 1:
        box_signal_handler.free_mouth_by_size_result.emit("Failure")
    mouth_type = mouth_type_list[0]
    mouth_param = {"mouthType_id": mouth_type['id'], "deleteFlag": 0, "status": "ENABLE"}
    mouth_list = BoxDao.get_free_mouth_by_type(mouth_param)
    if len(mouth_list) == 0:
        box_signal_handler.free_mouth_by_size_result.emit("Failure")
    box_signal_handler.free_mouth_by_size_result.emit("Success")


def get_free_mouth_by_size(mouth_size):
    mouth_type_param = {"name": mouth_size}
    mouth_type_list = BoxDao.get_mouth_type(mouth_type_param)
    if len(mouth_type_list) != 1:
        return False
    mouth_type = mouth_type_list[0]
    mouth_param = {"mouthType_id": mouth_type['id'], "deleteFlag": 0, "status": "ENABLE"}
    mouth_list = BoxDao.get_free_mouth_by_type(mouth_param)
    if len(mouth_list) == 0:
        return False
    return mouth_list[0]


def get_free_mouth_by_enable():
    mouth_param = {"deleteFlag": 0, "status": "ENABLE"}
    mouth_list = BoxDao.get_free_mouth_by_type_enable(mouth_param)
    if len(mouth_list) == 0:
        return False

    return mouth_list[0]


def get_box():
    order_no = Configurator.get_value("ClientInfo", "OrderNo")
    param = {"orderNo": order_no, "deleteFlag": 0}
    box_list = BoxDao.get_box_by_order_no(param)
    if len(box_list) != 1:
        return False
    return box_list[0]


def get_mouth(express__: object) -> object:
    return BoxDao.get_mouth(express__)


def free_mouth(mouth__):
    BoxDao.free_mouth(mouth__)


def use_mouth(mouth_param__):
    BoxDao.use_mouth(mouth_param__)


last_open_mouth_id = None
last_mouth_number = ""


def start_open_mouth():
    ClientTools.get_global_pool().apply_async(open_mouth)


def open_mouth(mouth_id: object = None) -> object:
    try:
        global last_open_mouth_id, last_mouth_number
        if mouth_id is None:
            logger.info(("open mouth again!", last_open_mouth_id))
            mouth_id = last_open_mouth_id
        else:

            logger.info(("open mouth id :", mouth_id))
            last_open_mouth_id = mouth_id
        mouth_list = BoxDao.get_mouth_by_id({"id": mouth_id})
        if len(mouth_list) != 1:
            logger.warn("mouth list error!")
            return
        _mouth = mouth_list[0]
        cabinet_list = BoxDao.get_cabinet_by_id({"id": _mouth["cabinet_id"]})
        if len(cabinet_list) != 1:
            logger.warn("cabinet list error!")
            return
        cabinet = cabinet_list[0]

        last_mouth_number = _mouth["number"]

        result = LockMachine.open_door(int(cabinet["number"]), int(_mouth["numberInCabinet"]))

        logger.debug(("LockMachine.open_door result is : ", result))
    except Exception as e:
        logger.warn(("open_mouth error :", e))


def start_get_mouth_status():
    ClientTools.get_global_pool().apply_async(get_mouth_status)


def get_mouth_status():
    result = ""
    for name in ["MINI", "L", "M", "S"]:
        param = {"status": "ENABLE", "name": name, "deleteFlag": 0}
        free_mouth_count = BoxDao.get_free_mouth_count_by_mouth_type_name(param)[0]
        if free_mouth_count["count"] > 0:
            result += "T"
        else:
            result += "F"
    box_signal_handler.mouth_status_signal.emit(result)


def start_load_manager_mouth_count():
    ClientTools.get_global_pool().apply_async(load_manager_mouth_count)


def load_manager_mouth_count():
    count_list = BoxDao.get_all_mouth_count({"deleteFlag": 0})
    logger.debug(("load_manager_mouth_count : ", len(count_list)))
    box_signal_handler.manager_mouth_count_signal.emit(count_list[0]["count"])


def start_load_mouth_list(page):
    ClientTools.get_global_pool().apply_async(manager_load_mouth_list, (page,))
    box_signal_handler.load_mouth_list_signal.emit("Success")


def manager_load_mouth_list(page):
    __user = user.service.UserService.get_user()
    get_mouth_param = {"deleteFlag": 0, "startLine": (int(page) - 1) * 25}
    if __user['role'] == "OPERATOR_USER" or __user['role'] == "OPERATOR_ADMIN":
        mouth_list_ = BoxDao.get_mouth_list(get_mouth_param)
        box_signal_handler.mouth_list_signal.emit(json.dumps(mouth_list_))


def start_manager_set_mouth(box_id, box_status):
    ClientTools.get_global_pool().apply_async(manager_set_mouth, (box_id, box_status,))


def manager_set_mouth(mouth_id, box_status):
    set_mouth_param = {"id": mouth_id, "status": box_status, "syncFlag": 0}
    BoxDao.manage_set_mouth(set_mouth_param)
    box_signal_handler.manager_set_mouth_signal.emit("Success")
    message, status_code = HttpClient.post_message("box/mouth/sync", set_mouth_param)
    if status_code == 200:
        BoxDao.mark_sync_success(set_mouth_param)


def start_manager_open_mouth(mouth_id):
    ClientTools.get_global_pool().apply_async(manager_open_mouth, (mouth_id,), callback=return_signal)


def start_manager_open_all_mouth():
    ClientTools.get_global_pool().apply_async(manager_open_all_mouth)


def manager_open_all_mouth():
    mouth_list = BoxDao.get_all_mouth({'deleteFlag': 0})
    for _mouth in mouth_list:
        manager_open_mouth(_mouth["id"])
    box_signal_handler.manager_open_all_mouth_signal.emit("Success")


def manager_open_mouth(mouth_id):
    __user = user.service.UserService.get_user()
    if __user['role'] != "OPERATOR_USER" and __user['role'] != "OPERATOR_ADMIN":
        box_signal_handler.manager_open_mouth_by_id_signal.emit("Error")
        return False
    open_mouth(mouth_id)
    return True


def return_signal(result):
    logger.debug(result)
    if not result:
        return
    box_signal_handler.manager_open_mouth_by_id_signal.emit("Success")


def start_manager_set_free_mouth(box_id):
    ClientTools.get_global_pool().apply_async(manager_set_free_mouth, (box_id,))


def manager_set_free_mouth(box_id):
    pass


mouth = None


def start_choose_mouth_size(mouth_size, method_type):
    ClientTools.get_global_pool().apply_async(choose_mouth_size, (mouth_size, method_type))


def start_choose_mouth_enable(method_type):
    ClientTools.get_global_pool().apply_async(choose_mouth_enable, (method_type,))


def choose_mouth_enable(method_type):
    global mouth
    logger.info((" type:", method_type))
    mouth = get_free_mouth_by_enable()
    if not mouth:
        mouth = None
        logger.warn("not  mouth!")
        box_signal_handler.choose_mouth_signal.emit("NotMouth")
        return
    else:
        open_mouth(mouth["id"])
        logger.info("open mouth id:" + str(mouth["id"]) + " number:" + str(mouth["number"]))
        box_signal_handler.choose_mouth_signal.emit("Success")


def choose_mouth_size(mouth_size, method_type):
    global mouth
    logger.info(("choose_mouth_size:", mouth_size, " type:", method_type))
    mouth = get_free_mouth_by_size(mouth_size)
    if not mouth:
        mouth = None
        logger.warn("not " + mouth_size + " mouth!")
        box_signal_handler.choose_mouth_signal.emit("NotMouth")
        return
    user_result = user.service.UserService.get_user()
    if method_type == "staff_store_express" and user_result['wallet']['balance'] < mouth['usePrice']:
        logger.warn("not enough money!")
        box_signal_handler.choose_mouth_signal.emit("NotBalance")
        return
    open_mouth(mouth["id"])
    logger.info("open mouth id:" + str(mouth["id"]) + " number:" + str(mouth["number"]))
    box_signal_handler.choose_mouth_signal.emit("Success")


def get_express_mouth_number():
    global last_mouth_number
    box_signal_handler.mouth_number_signal.emit(str(last_mouth_number))


def update_free_time(param):
    box_list = BoxDao.get_box_by_order_no({"orderNo": param["orderNo"], "deleteFlag": 0})
    if len(box_list) == 0:
        logger.warn("box not found!")
        return False
    param["overdueType"] = ClientTools.get_value("overdueType", param)
    param["freeDays"] = ClientTools.get_value("freeDays", param)
    param["freeHours"] = ClientTools.get_value("freeHours", param)
    BoxDao.update_free_time(param)
    return True


def start_get_free_mouth_mun():
    ClientTools.get_global_pool().apply_async(get_free_mouth_num)


def get_free_mouth_num():
    __result = {}
    __mouth_type_list = BoxDao.get_all_mouth_type({"deleteFlag": 0})
    for __mouth_type in __mouth_type_list:
        param = {"status": "ENABLE", "mouthType_id": __mouth_type["id"], "deleteFlag": 0}
        __free_mouth_count = BoxDao.get_count_by_status_and_mouth_type_id(param)[0]
        __result[__mouth_type["name"]] = __free_mouth_count["mouth_count"]
    box_signal_handler.free_mouth_num_signal.emit(json.dumps(__result))


def get_scan_not_sync_mouth_list():
    return BoxDao.get_not_sync_mouth_list({"syncFlag": 0})


def mark_sync_success(mouth_info):
    return BoxDao.mark_sync_success(mouth_info)


def mark_box_sync_success():
    return BoxDao.mark_box_sync_success({"deleteFlag": 0})


last_pull_open_mouth_id = None
last_pull_mouth_number = ""


def pull_open_mouth(message_result):
    global last_pull_open_mouth_id, last_pull_mouth_number
    if message_result["mouth"]["id"] is None:
        box_post_message(message_result["id"], "mouth_id is None", "ERROR")
        return
    else:
        logger.info(("Server_pull open mouth id :", message_result["mouth"]["id"]))
        last_pull_open_mouth_id = message_result["mouth"]["id"]
    mouth_list = BoxDao.get_mouth_by_id({"id": message_result["mouth"]["id"]})
    if len(mouth_list) != 1:
        box_post_message(message_result["id"], "mouth list error!", "ERROR")
        return
    _mouth = mouth_list[0]
    cabinet_list = BoxDao.get_cabinet_by_id({"id": _mouth["cabinet_id"]})
    if len(cabinet_list) != 1:
        box_post_message(message_result["id"], "cabinet list error!", "ERROR")
        return
    cabinet = cabinet_list[0]
    last_pull_mouth_number = _mouth["number"]
    result = LockMachine.open_door(int(cabinet["number"]), int(_mouth["numberInCabinet"]))
    if result is True:
        box_post_message(message_result["id"], "the mouth opened!", "SUCCESS")
    else:
        box_post_message(message_result["id"], "the mouth not opened!", "ERROR")


def box_post_message(task_id, result, reset_status):
    reset_express_result = {"id": task_id, "result": result, "statusType": reset_status}
    HttpClient.post_message("task/finish", reset_express_result)


def start_get_ups_status():
    ClientTools.get_global_pool().apply_async(get_ups_status)


def get_ups_status():
    UPSMachine.start_get_ups_status()


def start_update_mouth_status(message_result):
    ClientTools.get_global_pool().apply_async(update_mouth_status, (message_result,))


def update_mouth_status(message_result):
    try:
        logger.info(("update_mouth_status:", message_result))
        mouth_result = BoxDao.get_mouth_by_id({"id": message_result["mouth"]["id"]})
        logger.debug(("mouth_result is :", mouth_result))
        if len(mouth_result) == 0:
            box_post_message(message_result["id"], "no the mouth", "ERROR")
        else:
            mouth_param = {"id": message_result["mouth"]["id"], "status": message_result["mouth"]["status"]}
            BoxDao.update_mouth_status(mouth_param)
            box_post_message(message_result["id"], "update successful", "SUCCESS")
    except Exception as e:
        logger.warn(("update_mouth_status ERROR!!", e))
        box_post_message(message_result["id"], "update_mouth_status ERROR:", "ERROR")


def start_update_holiday(message_result):
    ClientTools.get_global_pool().apply_async(update_holiday, (message_result,))


def update_holiday(message_result):
    try:
        logger.info(("update_holiday : ", message_result))
        for _holiday in message_result['box']['holidays']:
            databases_holiday = BoxDao.get_holiday_by_id({'id': _holiday['id']})
            if len(databases_holiday) != 0:
                holiday_param = {'id': _holiday['id'], 'startTime': _holiday['startTime'],
                                 'endTime': _holiday['endTime'],
                                 'delayDay': _holiday['delayDays'], 'holidayType': _holiday['holidayType']}
                BoxDao.update_holiday(holiday_param)
            else:
                holiday_param = {'id': _holiday['id'], 'startTime': _holiday['startTime'],
                                 'endTime': _holiday['endTime'],
                                 'delayDay': _holiday['delayDays'], 'holidayType': _holiday['holidayType']}
                BoxDao.init_holiday(holiday_param)

        box_post_message(message_result["id"], "update SUCCESS", "SUCCESS")
    except Exception as e:
        logger.warn(("update_holiday ERROR!!", e))
        box_post_message(message_result["id"], "except error", "ERROR")


def start_delete_holiday(message_result):
    ClientTools.get_global_pool().apply_async(delete_holiday, (message_result,))


def delete_holiday(message_result):
    logger.info(("update_holiday : ", message_result))
    try:
        count = 0
        for _holiday in message_result['box']['holidays']:
            databases_holiday = BoxDao.get_holiday_by_id({'id': _holiday['id']})
            if len(databases_holiday) == 0:
                count += 1
            else:
                BoxDao.delete_holiday({'id': _holiday['id']})
        if count == len(message_result['box']['holidays']):
            box_post_message(message_result["id"], "all not find", "ERROR")
        elif count == 0:
            box_post_message(message_result["id"], "delete_holiday SUCCESS", "SUCCESS")
        else:
            box_post_message(message_result["id"], "same not find " + count, "ERROR")
    except Exception as e:
        logger.warn(("delete_holiday ERROR!!", e))
        box_post_message(message_result["id"], "except error", "ERROR")
