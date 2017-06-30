import logging
from multiprocessing.dummy import Pool
import uuid
import time
import datetime

import Configurator

__author__ = 'gaoyang'

logger = logging.getLogger()

pool = Pool(processes=16)


def get_global_pool():
    return pool


def get_port_value(device_name, default_baud_rate, default_port, default_timeout=1):
    if Configurator.get_value(device_name, "baudrate"):
        baudrate = Configurator.get_value(device_name, "baudrate")
    else:
        baudrate = default_baud_rate

    if Configurator.get_value(device_name, "port"):
        port = Configurator.get_value(device_name, "port")
    else:
        port = default_port

    if Configurator.get_value(device_name, "timeout"):
        timeout = Configurator.get_value(device_name, "timeout")
    else:
        timeout = default_timeout
    __result = {'baudrate': baudrate, 'port': port, 'timeout': timeout}
    logger.debug((device_name, __result))
    return __result


def now():
    return int(time.time()) * 1000


def today():
    now_time = time.time()
    midnight = now_time - (now_time % 86400) + time.timezone
    return int(midnight) * 1000


def today_time():
    now_time = time.time()
    midnight = now_time - (now_time % 86400) + time.timezone
    return int(midnight)


def time_str():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def get_uuid():
    return str(uuid.uuid1().hex)


def get_value(key: object, map_: object, default_value: object = None) -> object:
    if map_ is None:
        return default_value
    if key in map_.keys():
        return map_[key]
    return default_value
