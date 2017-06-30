import logging

from PyQt5.QtCore import QObject, pyqtSignal
import time

import ClientTools
import serial

__author__ = 'gaoyang'


class CoinMachineSignalHandler(QObject):
    coin_result = pyqtSignal(str)


coin_machine_signal_handler = CoinMachineSignalHandler()
logger = logging.getLogger()

port = None


def init_port():
    global port
    port = serial.Serial(**ClientTools.get_port_value("CoinMachine", 9600, 'COM1', 30))


def get_port():
    global port
    if port is None:
        init_port()
    return port


def close_port():
    global port
    if port:
        port.close()
        port = None


start_flag = False


def start_get_coin():
    global start_flag
    logger.debug(("start_flag: ", start_flag))
    if not start_flag:
        start_flag = True
        ClientTools.get_global_pool().apply_async(get_coin)


def get_coin():
    global start_flag
    get_port().write((0x90, 0x05, 0x01, 0x03, 0x99))
    receive_data = get_port().read(5)
    logger.info(receive_data)
    if not check_data(receive_data):
        close_port()
        coin_machine_signal_handler.coin_result.emit("False")
        start_flag = False
        return False
    receive_data = get_port().read(6)
    if not check_data(receive_data):
        close_port()
        coin_machine_signal_handler.coin_result.emit("False")
        start_flag = False
        return False
    get_port().write((0x90, 0x05, 0x02, 0x03, 0x9A))
    get_port().read(5)
    if receive_data[2] == 0x12:
        coin_machine_signal_handler.coin_result.emit("True")
    else:
        close_port()
        coin_machine_signal_handler.coin_result.emit("False")
    # time.sleep(2)
    # coin_machine_signal_handler.coin_result.emit("True")
    start_flag = False


def check_data(data):
    if len(data) < 5:
        return False
    check_sum = 0
    for x in range(0, data[1] - 1):
        check_sum += data[x]
    return data[data[1] - 1] == check_sum
