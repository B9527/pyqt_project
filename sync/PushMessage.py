import os
import time
import logging

import ClientTools
import Configurator
import alert.service.AlertService
import box.service.BoxService
from device import UPSMachine
import download.repository.DownloadDao
import download.service.DownloadService
from alert.repository import AlertDao
import express.service.ExpressService
from network import HttpClient
from upload.service import UploadService

__author__ = 'gaoyang'

start_flag = True
upgrade_flag = True
default_encoding = 'utf-8'
logger = logging.getLogger()
main_page_flag = True
init_client_task = False
init_task_id = ""


def sync_express():
    try:
        express_list = express.service.ExpressService.get_scan_not_sync_express_list()
        if len(express_list) == 0:
            return
        for express_ in express_list:
            if (ClientTools.get_value("storeTime", express_, default_value=0) > (ClientTools.now() - 30000)) or \
                    (ClientTools.get_value("takeTime", express_, default_value=0) > (ClientTools.now() - 30000)):
                continue
            logger.info(express_)
            express_["storeUser"] = {"id": ClientTools.get_value("storeUser_id", express_, None)}
            express_["mouth"] = {"id": express_["mouth_id"]}
            express_["logisticsCompany"] = {"id": ClientTools.get_value("logisticsCompany_id", express_, None)}
            transaction_record = express.service.ExpressService.get_scan_sync_express_transaction_record(
                {"express_id": express_["id"]})
            if len(transaction_record) != 0:
                express_["transactionRecords"] = transaction_record
            if "groupName" in express_.keys():
                express_["groupName"] = express_["groupName"]
            if "staffTakenUser_id" in express_.keys():
                express_["staffTakenUser"] = {"id": express_["staffTakenUser_id"]}
            message, status_code = HttpClient.post_message("express/syncExpress", express_)
            if status_code == 200:
                logger.info(message)
                express.service.ExpressService.mark_sync_success(express_)
                # if SYNC_EXPRESS ,recover
                alert.service.AlertService.start_alert_recovery("SYNC_EXPRESS", express_["id"])
            elif status_code != 200 or status_code != -1:
                logger.warning(message)
                alert.service.AlertService.start_alert_abnormal("SYNC_EXPRESS", express_["id"])
            else:
                logger.warning(message)
    except Exception as e:
        logger.error(("sync_express ERROR :", e))


def sync_mouth():
    try:
        mouth_list = box.service.BoxService.get_scan_not_sync_mouth_list()
        for mouth in mouth_list:
            message, status_code = HttpClient.post_message("box/mouth/sync", mouth)
            if status_code == 200:
                box.service.BoxService.mark_sync_success(mouth)
                # if SYNC_MOUTH ,recover
                alert.service.AlertService.start_alert_recovery("SYNC_MOUTH", mouth["id"])
            elif status_code != 200 or status_code != -1:
                alert.service.AlertService.start_alert_abnormal("SYNC_MOUTH", mouth["id"])
            else:
                logger.warning(message)
    except Exception as e:
        logger.error(("sync_mouth ERROR :", e))


def sync_box():
    try:
        box_info = box.service.BoxService.get_box()
        logger.info(box_info)
        if box_info["syncFlag"] == 0:
            message, status_code = HttpClient.post_message("box/sync", box_info)
            if status_code == 200:
                box.service.BoxService.mark_box_sync_success()
            else:
                logger.warning(message)
    except Exception as e:
        logger.error(("sync_box ERROR :", e))


def check_ups():
    try:
        UPSMachine.get_ups_status()
        ups_status = UPSMachine.ups_status_result
        logger.info(("ups_status_result is :", ups_status))
    except Exception as e:
        logger.error(("check_ups ERROR :", e))


def sync_alert():
    try:
        box_id = box.service.BoxService.get_box()
        alert_record = AlertDao.check_not_sync({"syncFlag": 0})
        for record in alert_record:
            record["box"] = box_id
            record["operator"] = {"id": box_id["operator_id"]}
            message, status_code = HttpClient.post_message("alert/create", record)
            if status_code == 200:
                AlertDao.mark_alert_sync_success(record)
            else:
                logger.warning(message)
    except Exception as e:
        logger.error(("sync_ups ERROR :", e))


def check_download_info():
    try:
        param = {"status": "0"}
        info_list = download.repository.DownloadDao.get_all_download_info(param)
        logger.info(("download_info_list is :", info_list))
        if len(info_list) == 0:
            return
        for __info in info_list:
            logger.debug(__info)
    except Exception as e:
        logger.error(("check_download_info ERROR :", e))


def zip_log():
    try:
        cur = time.localtime()
        if cur.tm_hour == 1:
            UploadService.start_zip_log_file()
    except Exception as e:
        logger.error(("zip_log ERROR :", e))


def sync_message():
    global start_flag
    while start_flag:
        sync_express()
        sync_mouth()
        sync_box()
        check_ups()
        sync_alert()
        zip_log()
        time.sleep(30)


def set_start_flag(flag):
    global start_flag
    start_flag = flag


def start_sync_message():
    ClientTools.get_global_pool().apply_async(sync_message)


def start_time_task():
    ClientTools.get_global_pool().apply_async(time_task)


def time_task():
    global start_flag
    while start_flag:
        init_client_by_server()
        time.sleep(10)


def init_client_by_server():
    global init_client_task, main_page_flag, init_task_id
    try:
        if main_page_flag and init_client_task:
            box.service.BoxService.init_client()
            init_client_task = False
            reset_express_result = {"id": init_task_id, "result": "init finish", "statusType": "SUCCESS"}
            HttpClient.post_message("task/finish", reset_express_result)
    except Exception as e:
        init_client_task = False
        logger.error(("init_client_by_server ERROR :", e))
        reset_express_result = {"id": init_task_id, "result": "init except", "statusType": "ERROR"}
        HttpClient.post_message("task/finish", reset_express_result)


def start_upgrade_task():
    ClientTools.get_global_pool().apply_async(upgrade_task)


def upgrade_task():
    global upgrade_flag
    while upgrade_flag:
        upgrade_box()
        time.sleep(10)


def upgrade_box():
    global main_page_flag
    try:
        cur = time.localtime()
        if cur.tm_hour == 0:
            upgrade_info = download.repository.DownloadDao.get_upgrade_info({"type": "UPGRADE_BOX", "status": "finish"})
            if len(upgrade_info) == 0:
                return
            else:
                _upgrade_info = upgrade_info[0]
                if _upgrade_info["initFlag"] == 1:  # update and init client
                    Configurator.set_value("Upgrade", "initFlag", "1")

            while 1:
                if main_page_flag:
                    download.repository.DownloadDao.update_upgrade_info_for_deleteflag({"id": upgrade_info[0]["id"]})
                    os.system("upgradeIM.EXE")
    except Exception as e:
        logger.error(("upgrade_box ERROR :", e))
