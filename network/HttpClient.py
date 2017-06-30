import logging

import requests

import Configurator
import box.service.BoxService

NOT_INTERNET_ = {'statusCode': -1, 'statusMessage': 'Not Internet'}

__author__ = 'gaoyang'

url = Configurator.get_value("ClientInfo", "ServerAddress")
order_no = Configurator.get_value("ClientInfo", "OrderNo")
box_token = Configurator.get_value("ClientInfo", "Token")
user_token = ""
disk_serial_number = ""

logger = logging.getLogger()


def set_user_token(token):
    global user_token
    user_token = token


def clean_user_token():
    global user_token
    user_token = ""


def get_header():
    global disk_serial_number, user_token, order_no, box_token
    try:
        box_info = box.service.BoxService.get_box()
        if box_info is not False:
            box_id = box_info['id']
        else:
            box_id = None
    except Exception as e:
        box_id = None
        logger.debug("get_header box_info error", e)
    version = box.service.BoxService.version
    header = {'id': box_id, 'OrderNo': order_no, 'BoxToken': box_token, 'Version': version,
              'DiskSerialNumber': disk_serial_number}
    if user_token != "":
        header['UserToken'] = user_token
    return header


def get_message(url_param, msg=None):
    header = get_header()
    logger.info("header:" + str(header) + "url:" + str(url_param) + "; json: " + str(msg))
    try:
        r = requests.get(url + url_param, headers=header, json=msg, timeout=50)
    except requests.RequestException:
        logger.warning((NOT_INTERNET_, -1))
        return NOT_INTERNET_, -1
    try:
        r_json = r.json()
    except ValueError:
        logger.warning(("ValueError", r.status_code))
        return NOT_INTERNET_, r.status_code
    logger.info((r_json, r.status_code))
    return r_json, r.status_code


def post_message(url_param, msg=None, logger_flag=True):
    header = get_header()
    if logger_flag:
        logger.info("url:" + str(url_param) + "; json: " + str(msg))
    try:
        r = requests.post(url + url_param, headers=header, json=msg, timeout=50)
    except requests.RequestException:
        logger.warning((NOT_INTERNET_, -1))
        return NOT_INTERNET_, -1
    try:
        r_json = r.json()
    except ValueError:
        logger.warning(("ValueError", r.status_code))
        return NOT_INTERNET_, r.status_code
    logger.info((r_json, r.status_code))
    return r_json, r.status_code
