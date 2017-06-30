import logging
import time

from PyQt5.QtCore import QObject, pyqtSignal
import serial

import ClientTools
from alert.service import AlertService

default_encoding = 'utf-8'
logger = logging.getLogger()
ups_start_flag = False
ups_machine_port = None
ups_status_result = ""


class UPSSignalHandler(QObject):
    ups_result = pyqtSignal(str)


ups_signal_handler = UPSSignalHandler


def start():
    global ups_machine_port
    ups_machine_port = serial.Serial(**ClientTools.get_port_value("Ups", 2400, 'COM2'))


def start_get_ups_status():
    ClientTools.get_global_pool().apply_async(get_ups_status)


def get_ups_status():
    global ups_status_result
    try:
        get_port().write((0x51, 0x31, 0x0d))
        time.sleep(2)
        ups_status = get_port().readline()
        ups_status_all = str(ups_status)
        logger.info(("ups_status is :", ups_status))
        if len(ups_status_all) < 8:
            return
        ups_status_result = ups_status_all.split(' ')[7][0:8]
        logger.info(("ups_status_result is :", ups_status_result))
        record_ups_status()
    except Exception as e:
        logger.error(("get_ups_status ERROR :", e))


def close_port():
    global ups_machine_port
    try:
        ups_machine_port.close()
    finally:
        ups_machine_port = None


def get_port():
    if ups_machine_port is None:
        start()
    return ups_machine_port


def record_ups_status():
    global ups_status_result
    try:
        input_status = ups_status_result[0:1]
        battery_status = ups_status_result[1:2]
        bypass_status = ups_status_result[2:3]
        ups_error_status = ups_status_result[3:4]
        ups_type_status = ups_status_result[4:5]
        shutdown_status = ups_status_result[6:7]
        if int(input_status + battery_status + bypass_status + ups_error_status + ups_type_status + shutdown_status,
               2) > 0:
            AlertService.alert_abnormal("UPS", "ERROR")
        if int(input_status + battery_status + bypass_status + ups_error_status + ups_type_status + shutdown_status,
               2) == 0:
            AlertService.alert_recovery("UPS", "ERROR")
    except Exception as e:
        logger.error(("record_ups_status ERROR :", e))
