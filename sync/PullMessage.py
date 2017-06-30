import logging
import time

import ClientTools
from box.repository import BoxDao
from network import HttpClient
import box.service.BoxService
import express.service.ExpressService
import download.repository.DownloadDao
import download.service.DownloadService

import sync.PushMessage

__author__ = 'gaoyang'

logger = logging.getLogger()


def start_pull_message():
    ClientTools.get_global_pool().apply_async(pull_message)


def pull_message():
    while True:
        try:
            message, status_code = HttpClient.get_message("box/pull")
            if status_code == 200:
                parsing_message(message)
            else:
                time.sleep(5)
        except Exception as e:
            logger.error(("pull_message ERROR :", e))


def parsing_message(push_message_list):
    if len(push_message_list) == 0:
        return
    for message_result in push_message_list:
        if message_result["pushMessageType"] == "BOX_START_TIME_CHANGE":
            if not box.service.BoxService.update_free_time(message_result["value"]):
                continue
            message_result["value"] = message_result["value"]["id"]
            HttpClient.post_message("box/finish", message_result)
        if message_result["pushMessageType"] == "MOUTH_STATUS_CHANGE":
            BoxDao.update_mouth_status(message_result["value"])
            message_result["value"] = message_result["value"]["id"]
            HttpClient.post_message("box/finish", message_result)
        if message_result["pushMessageType"] == "INIT_CLIENT":
            box.service.BoxService.start_init_client()
            message_result["value"] = message_result["value"]["id"]
            HttpClient.post_message("box/finish", message_result)

        if message_result["pushMessageType"] == "STORE_EXPRESS":
            express.service.ExpressService.start_service_pull_store_express(message_result["value"],
                                                                            message_result["timestamp"])
            message_result["value"] = message_result["value"]["id"]
            HttpClient.post_message("box/finish", message_result)

        if message_result["pushMessageType"] == "ASYNC_TASK":
            timeout = ClientTools.get_value("timeout", message_result["value"])
            if timeout is not None and timeout < ClientTools.now():
                result = {"id": message_result["value"]["id"], "result": "TimeOut", "statusType": "ERROR"}
                HttpClient.post_message("task/finish", result)
                continue

            if message_result["value"]["taskType"] == "RESET_EXPRESS":
                express.service.ExpressService.start_reset_express(message_result["value"])

            if message_result["value"]["taskType"] == "REMOTE_UNLOCK":
                box.service.BoxService.pull_open_mouth(message_result["value"])

            if message_result["value"]["taskType"] == "UPDATE_BOX":
                box.service.BoxService.start_update_box(message_result["value"])

            if message_result["value"]["taskType"] == "MOUTH_STATUS_CHANGE":
                box.service.BoxService.start_update_mouth_status(message_result["value"])

            if message_result["value"]["taskType"] == "UPDATE_ADVERT":
                download.service.DownloadService.pre_download_source(message_result["value"])

            if message_result["value"]["taskType"] == "DELETE_ADVERT":
                download.service.DownloadService.start_delete_source(message_result["value"])

            if message_result["value"]["taskType"] == "UPDATE_HOLIDAY":
                box.service.BoxService.start_update_holiday(message_result["value"])

            if message_result["value"]["taskType"] == "DELETE_HOLIDAY":
                box.service.BoxService.start_delete_holiday(message_result["value"])

            if message_result["value"]["taskType"] == "INIT_BOX":
                sync.PushMessage.init_client_task = True
                sync.PushMessage.init_task_id = message_result["value"]["id"]
                reset_express_result = {"id": message_result["value"]["id"], "result": "init finish",
                                        "statusType": "SUCCESS"}
                HttpClient.post_message("task/finish", reset_express_result)

            if message_result["value"]["taskType"] == "UPGRADE_BOX":
                download.service.DownloadService.pre_download_source(message_result["value"])
