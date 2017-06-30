import hashlib
import json
import logging
from PyQt5.QtCore import QObject, pyqtSignal
import sys
import shutil
import ClientTools
import requests
import os
import time
import download.repository.DownloadDao
from network import HttpClient

__author__ = 'victor.choi'
logger = logging.getLogger()
NOT_INTERNET_ = {'statusCode': -1, 'statusMessage': 'Not Internet'}
default_encoding = 'utf-8'


class DownloadSignalHandler(QObject):
    ad_download_result_signal = pyqtSignal(str)
    delete_result_signal = pyqtSignal(str)


download_signal_handler = DownloadSignalHandler()
download_info = ""
dst_dir = ""


def start_delete_source(message_result):
    ClientTools.get_global_pool().apply_async(delete_source, (message_result,))


def delete_source(message_result):
    try:
        # ADVERT
        if message_result["taskType"] == "DELETE_ADVERT":
            if not os.path.exists(sys.path[0] + "/advertisement/source"):
                delete_post_message(message_result["id"], "path is not exist", "ERROR")
            path_dir = os.path.join(os.getcwd(), "advertisement", "source")
            position = str(message_result["advert"]["position"])
            # find files in path_dir
            for file_name in os.listdir(path_dir):
                if os.path.isfile(os.path.join(path_dir, file_name)) is True:
                    _file_name = file_name.split('.')[0]
                    if _file_name == position:
                        os.remove(os.path.join(path_dir, file_name))
                        download_signal_handler.delete_result_signal.emit("ok")
                        delete_post_message(message_result["id"], "delete source finish", "SUCCESS")
                    else:
                        delete_post_message(message_result["id"], "the position is not exist", "ERROR")
        # music
        if message_result["taskType"] == "music":
            if not os.path.exists(sys.path[0] + "/music/source"):
                delete_post_message(message_result["id"], "path is not exist", "ERROR")
            path_dir = os.path.join(os.getcwd(), "music", "source")
    except Exception as e:
        logger.error(("pre_download_source ERROR :", e))
        delete_post_message(message_result["id"], "delete_source except error", "ERROR")


def start_download_source(message_result):
    ClientTools.get_global_pool().apply_async(pre_download_source, (message_result,))


def pre_download_source(message_result):  # �������ݿ�
    global download_info
    try:
        download_info = message_result
        flag_time = ClientTools.now()
        if "advert" in message_result:
            param = {"id": message_result["advert"]["doc"]["id"], "url": message_result["advert"]["doc"]["id"],
                     "filename": message_result["advert"]["doc"]["displayName"], "status": "Not downloaded",
                     "type": message_result["taskType"], "MD5": message_result["advert"]["doc"]["md5"],
                     "flagTime": flag_time,
                     "position": message_result["advert"]["position"], "version": None, "initFlag": None,
                     "deleteFlag": 0}
            check_result = download.repository.DownloadDao.check_download_by_id(
                {"id": message_result["advert"]["doc"]["id"]})
            if len(check_result) == 0:
                download.repository.DownloadDao.insert_download_info(param)
            else:
                flag_time = check_result[0]["flagTime"]

            download_file_patch = {"id": message_result["advert"]["doc"]["id"],
                                   "url": message_result["advert"]["doc"]["id"],
                                   "filename": message_result["advert"]["doc"]["displayName"],
                                   "type": message_result["taskType"], "flagTime": flag_time,
                                   "position": message_result["advert"]["position"]}
            download_mk_dir(download_file_patch)  # ����Ŀ¼����������Ŀ¼

        elif "boxVersion" in message_result:
            param = {"id": message_result["boxVersion"]["clientFile"]["id"],
                     "url": message_result["boxVersion"]["clientFile"]["id"],
                     "filename": message_result["boxVersion"]["clientFile"]["displayName"], "status": "Not downloaded",
                     "type": message_result["taskType"], "MD5": message_result["boxVersion"]["clientFile"]["md5"],
                     "flagTime": flag_time,
                     "version": message_result["boxVersion"]["name"], "position": None,
                     "initFlag": message_result["boxVersion"]["initFlag"], "deleteFlag": 0}
            check_result = download.repository.DownloadDao.check_download_by_id(
                {"id": message_result["boxVersion"]["clientFile"]["id"]})
            if len(check_result) == 0:
                download.repository.DownloadDao.insert_download_info(param)
            else:
                flag_time = check_result[0]["flagTime"]

            download_file_patch = {"id": message_result["boxVersion"]["clientFile"]["id"],
                                   "url": message_result["boxVersion"]["clientFile"]["id"],
                                   "filename": message_result["boxVersion"]["clientFile"]["displayName"],
                                   "type": message_result["taskType"], "flagTime": flag_time,
                                   "version": message_result["boxVersion"]["name"], "position": None}
            download_mk_dir(download_file_patch)  # ����Ŀ¼����������Ŀ¼

        else:
            return

    except Exception as e:
        logger.error(("pre_download_source ERROR :", e))
        download_post_message(download_info["id"], "update databases error", "ERROR")


def download_mk_dir(download_file_patch):
    global download_info, dst_dir
    try:
        if download_file_patch["type"] == "UPDATE_ADVERT":
            if not os.path.exists(sys.path[0] + "/advertisement/source_temp"):
                os.makedirs(sys.path[0] + "/advertisement/source_temp")
            dst_dir = os.path.join(os.getcwd(), "advertisement", "source_temp")
        if download_file_patch["type"] == "UPGRADE_BOX":
            if not os.path.exists(
                    os.path.join(os.path.abspath(os.path.join(os.path.dirname('PakpoboxClient.py'), os.path.pardir)),
                                 "system", "source_temp")):
                os.makedirs(
                    os.path.join(os.path.abspath(os.path.join(os.path.dirname('PakpoboxClient.py'), os.path.pardir)),
                                 "system", "source_temp"))
            if not os.path.exists(
                    os.path.join(os.path.abspath(os.path.join(os.path.dirname('PakpoboxClient.py'), os.path.pardir)),
                                 "system", "source")):
                os.makedirs(
                    os.path.join(os.path.abspath(os.path.join(os.path.dirname('PakpoboxClient.py'), os.path.pardir)),
                                 "system", "source"))
            dst_dir = os.path.join(os.path.abspath(os.path.join(os.path.dirname('PakpoboxClient.py'), os.path.pardir)),
                                   "system", "source_temp")
        if download_file_patch["type"] == "music":
            if not os.path.exists(sys.path[0] + "/music/source_temp"):
                os.makedirs(sys.path[0] + "/music/source_temp")
            dst_dir = os.path.join(os.getcwd(), "music", "source_temp")

        main_download_file(download_file_patch)
        download_post_message(download_info["id"], "download file finish", "SUCCESS")
        remove_file(download_file_patch)
    except Exception as e:
        logger.error(("download_mk_dir ERROR :", e))
        download_post_message(download_info["id"], "download_mk_dir except error", "ERROR")


def main_download_file(download_file_patch):
    global dst_dir, download_info
    try:
        while True:
            downloaded_filename = download_file(download_file_patch)
            md5 = md5sum(os.path.join(dst_dir, downloaded_filename))
            correct_md5 = download.repository.DownloadDao.get_md5_by_id({"id": download_file_patch["id"]})[0]
            if md5 != correct_md5["MD5"]:
                download.repository.DownloadDao.update_download_info_status(
                    {"status": "MD5 error", "id": download_file_patch["id"]})
                os.remove(os.path.join(dst_dir, download_file_patch["filename"]))
                time.sleep(3)
            else:
                download.repository.DownloadDao.update_download_info_end(
                    {"status": "finish", "endTime": ClientTools.now(), "id": download_file_patch["id"]})
                return
    except Exception as e:
        logger.error(("main_download_file ERROR :", e))
        download_post_message(download_info["id"], "main_download_file except error", "ERROR")


def download_file(file_path):
    global download_info, dst_dir
    try:
        download.repository.DownloadDao.update_download_info_start(
            {"status": "start", "startTime": ClientTools.now(), "id": file_path["id"]})
        url = HttpClient.url + "file/clientDownload/" + file_path["url"]
        # url = HttpClient.url + "/" + file_path["filename"]
        header = HttpClient.get_header()
        try:
            r = requests.get(url, stream=True, headers=header, timeout=50)
            with open(os.path.join(dst_dir, file_path["filename"]), 'wb') as f:
                for chunk in r.iter_content(chunk_size=1024):
                    if chunk:  # filter out keep-alive new chunks
                        f.write(chunk)
                        f.flush()
            return file_path["filename"]
        except requests.RequestException:
            logger.warning((NOT_INTERNET_, -1))
    except Exception as e:
        download.repository.DownloadDao.update_download_info_status({"status": "download error", "id": file_path["id"]})
        logger.error(("download_file ERROR :", e))
        download_post_message(download_info["id"], "download_file except error", "ERROR")


def md5sum(filename):
    try:
        fd = open(filename, "rb")
        f_cont = fd.read()
        fd.close()
        fmd5 = hashlib.md5(f_cont)
        return fmd5.hexdigest()
    except Exception as e:
        logger.error(("md5sum ERROR :", e))


def remove_file(file_list):
    global dst_dir, download_info
    try:
        while 1:
            old_path = dst_dir
            new_path = os.path.join(dst_dir[0:(dst_dir.find("source_temp") - 1)], "source")
            if "advert" in download_info:
                new_file_name = str(file_list["position"]) + '.' + file_list["filename"].split('.')[-1]
                os.rename(os.path.join(old_path, file_list["filename"]), os.path.join(old_path, new_file_name))
                for file_name in os.listdir(new_path):
                    if os.path.isfile(os.path.join(new_path, file_name)) is True:
                        _file_name = file_name.split('.')[0]
                        if _file_name == str(file_list["position"]):
                            os.remove(os.path.join(new_path, file_name))
                            shutil.copy(os.path.join(old_path, new_file_name), os.path.join(new_path, new_file_name))
                        else:
                            shutil.copy(os.path.join(old_path, new_file_name), os.path.join(new_path, new_file_name))
                os.remove(os.path.join(old_path, new_file_name))

            if "boxVersion" in download_info:
                shutil.copy(os.path.join(old_path, download_info["boxVersion"]["clientFile"]["displayName"]),
                            os.path.join(new_path, download_info["boxVersion"]["clientFile"]["displayName"]))
                os.remove(os.path.join(old_path, download_info["boxVersion"]["clientFile"]["displayName"]))

            if file_list["type"] == "UPDATE_ADVERT":
                download_signal_handler.ad_download_result_signal.emit("ok")

            return
    except Exception as e:
        logger.error(("remove_file ERROR :", e))


def download_post_message(task_id, result, reset_status):
    reset_express_result = {"id": task_id, "result": result, "statusType": reset_status}
    HttpClient.post_message("task/finish", reset_express_result)


def delete_post_message(task_id, result, reset_status):
    reset_express_result = {"id": task_id, "result": result, "statusType": reset_status}
    HttpClient.post_message("task/finish", reset_express_result)


def check_position_file_name(path, position):
    for file_name in os.listdir(path):
        if os.path.isfile(os.path.join(path, file_name)) is True:
            _file_name = file_name.split('.')[0]
            if _file_name == position:
                os.remove(os.path.join(path, file_name))
            else:
                logger.debug("not file")
