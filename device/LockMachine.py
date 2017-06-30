import logging
import threading
from PyQt5.QtCore import QObject, pyqtSignal
import time

import Configurator
import ClientTools
import codecs
import serial

__author__ = 'gaoyang'

lock_machine_port = None
cabinet_count = 16
door_count = 24
lock = threading.Lock()
logger = logging.getLogger()
lock_version = Configurator.get_or_set_value("LockMachine", "version", default="1")
buffer_range_count = ""


class LockMachineHandler(QObject):
    open_door_result = pyqtSignal(str)


def start():
    global cabinet_count, lock_machine_port, lock_version, buffer_range_count
    if Configurator.get_value("LockMachine", "cabinet_count"):
        cabinet_count = Configurator.get_value("LockMachine", "cabinet_count")
    try:
        lock_machine_port = serial.Serial(**ClientTools.get_port_value("LockMachine", 38400, 'COM2'))
        print("start lock_machine_port is:" + lock_machine_port)
        if lock_version == "1":
            buffer_range_count = 8
        elif lock_version == "2":
            buffer_range_count = 5
    except Exception as e:
        print(e)
        logger.warn(e)


def start_open_door(cabinet_id, door_id, default=True):
    ClientTools.get_global_pool().apply_async(open_door, (cabinet_id, door_id, default))


def open_door(cabinet_id, door_id, default=True):
    _start_time = ClientTools.now()
    print("lock_version is:" + lock_version)
    try:
        lock.acquire()
        if lock_version == "1":
            get_port().write(
                (cabinet_id - 1 + 0xA0, 3, door_id, ((cabinet_id - 1 + 0xA0 + 3 + door_id) ^ 255) % 0x100))
        elif lock_version == "2":
            get_port().write(
                (cabinet_id - 1 + 0xA0, 4, door_id - 1, 0x01,
                 ((cabinet_id - 1 + 0xA0 + 4 + door_id - 1 + 0x01) ^ 255) % 0x100))
        logger.info((cabinet_id, door_id))
        time.sleep(0.1)
        while True:
            if ClientTools.now() - _start_time >= 2000:
                return False
            if lock_version == "1":
                if get_cabinet_status(cabinet_id)[int(door_id) - 1] == 1:
                    return True
            elif lock_version == "2":
                if get_cabinet_status(cabinet_id, door_id) == 1:
                    return True
            time.sleep(0.5)
    except Exception as e:
        logger.warn(e)
        close_port()
        return default
    finally:
        lock.release()


def start_get_cabinet_status(cabinet_id):
    ClientTools.get_global_pool().apply_async(get_cabinet_status, (cabinet_id,))


def get_cabinet_status(cabinet_id, door_id=None):
    for x in range(0, 3):
        try:
            if lock_version == "1":
                get_port().write(
                    (0xA0 + cabinet_id - 1, 0x03, 0xAA, ((0xA0 + cabinet_id - 1 + 0x03 + 0xAA) ^ 255) % 0x100))
                buffer = list()
                for i in range(20):
                    receive_data = get_port().read(1)
                    if receive_data == b'':
                        break
                    buffer.append(receive_data)
                    if len(buffer) > 9:
                        buffer.pop(0)

                    if len(buffer) == 9 and check_data(buffer):
                        logger.info(buffer)
                        __receive_data = buffer_com(buffer)
                        return convert_lock_status(__receive_data)

            if lock_version == "2":
                get_port().write(((cabinet_id - 1 + 0xA0), 4, (door_id - 1), 0x10,
                                  ((cabinet_id - 1 + 0xA0 + 4 + door_id - 1 + 0x10) ^ 255) % 0x100))
                buffer = list()
                for i in range(20):
                    receive_data = get_port().read(1)
                    if receive_data == b'':
                        break
                    buffer.append(receive_data)
                    if len(buffer) > 5:
                        buffer.pop(0)

                    if len(buffer) == 5 and check_data(buffer):
                        logger.info(buffer)
                        __receive_data = buffer_com(buffer)
                        return convert_lock_status(__receive_data)

        except (IOError, serial.SerialTimeoutException):
            close_port()
    return None


def buffer_com(data):
    global buffer_range_count
    com = b''
    for i in range(0, buffer_range_count):
        com += data[i]
    return com


def close_port():
    global lock_machine_port
    try:
        lock_machine_port.close()
    finally:
        lock_machine_port = None


def check_data(data):
    global lock_version
    result = 0
    __check_data = buffer_com(data)
    if lock_version == "1":
        for i in range(0, 8):
            result += __check_data[i]
        logger.debug(("check_data data is :", result))
        result ^= 0xFF
        logger.debug(("check_data result ^= :", result))
        return (result & 0xFF) == int(codecs.encode(data[8], "hex"), 16)

    if lock_version == "2":
        for i in range(0, 4):
            result += __check_data[i]
        logger.debug(("check_data data is :", result))
        result ^= 0xFF
        logger.debug(("check_data result ^= :", result))
        return (result & 0xFF) == __check_data[4]

    return False


def convert_lock_status(receive_data):
    global lock_version
    if lock_version == "1":
        all_lock_status = (receive_data[4] * 0x100 + receive_data[3]) * 0x100 + receive_data[2]
        logger.debug(("convert_lock_status all_lock_status is :", all_lock_status))
        return ClientTools.get_global_pool().map(lambda x: (all_lock_status & (1 << x)) == 0, range(0, door_count))

    if lock_version == "2":
        all_lock_status = receive_data[3]
        logger.debug(("convert_lock_status all_lock_status is :", all_lock_status))
        if (all_lock_status & 32) != 0:
            return "ERROR"
        return (all_lock_status & 1) == 0

    return None


def get_port():
    if lock_machine_port is None:
        start()
    return lock_machine_port
