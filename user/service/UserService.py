import hashlib
import json

from PyQt5.QtCore import QObject, pyqtSignal

import ClientTools
import box.service.BoxService
from network import HttpClient

__author__ = 'gaoyang'


class UserSignalHandler(QObject):
    user_login_signal = pyqtSignal(str)
    user_info_signal = pyqtSignal(str)
    courier_get_user_signal = pyqtSignal(str)


user_signal_handler = UserSignalHandler()
user_type = ""
user = ""


def background_login_start(username, password, identity):
    global user_type
    user_type = identity
    ClientTools.get_global_pool().apply_async(login, (username, password))


def get_user():
    global user
    return user


def select_wallet_for_box():
    global user
    user["wallet"] = {"balance": 0}
    __box_result = box.service.BoxService.get_box()
    if __box_result is False:
        return
    if "currencyUnit" not in __box_result.keys():
        return
    __box_currency_unit = __box_result["currencyUnit"]
    __user_wallets = user["wallets"]
    for __wallet in __user_wallets:
        if __wallet["currencyUnit"] != __box_currency_unit:
            continue
        user["wallet"] = __wallet


def login(username, password):
    global user, user_type
    if not password:
        user_signal_handler.user_login_signal.emit("Failure")
        return
    __user = {'loginName': username, 'password': password}
    __message, status_code = HttpClient.post_message('user/clientLogin', __user, logger_flag=False)
    if status_code == 500:
        user_signal_handler.user_login_signal.emit("NetworkError")
        return
    if status_code != 200:
        user_signal_handler.user_login_signal.emit("Failure")
        return
    user = __message
    select_wallet_for_box()
    HttpClient.set_user_token(__message['token'])
    if user_type == "LOGISTICS_COMPANY_USER":
        if user_type == __message['role'] or "LOGISTICS_COMPANY_ADMIN" == __message['role']:
            user_signal_handler.user_login_signal.emit("Success")
        else:
            user_signal_handler.user_login_signal.emit("NoPermission")
    if user_type == "OPERATOR_USER":
        if user_type == __message['role'] or "OPERATOR_ADMIN" == __message['role']:
            user_signal_handler.user_login_signal.emit("Success")
        else:
            user_signal_handler.user_login_signal.emit("NoPermission")


def get_user_info():
    global user
    info = {"name": user["name"], "phoneNumber": user["phoneNumber"], "company_name": user["company"]["name"]}
    user_signal_handler.user_info_signal.emit(json.dumps(info))


def courier_get_user():
    global user
    user_signal_handler.courier_get_user_signal.emit(json.dumps(user))
