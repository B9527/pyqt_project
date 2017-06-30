import logging
from PyQt5.QtCore import QObject, pyqtSignal
import ClientTools
import zlib
import serial
import base64

scanner = None
logger = logging.getLogger()


class ScannerSignalHandler(QObject):
    barcode_result = pyqtSignal(str)


scanner_signal_handler = ScannerSignalHandler()


def get_scanner():
    if scanner is None:
        init_scanner()
    return scanner


def init_scanner():
    global scanner
    try:
        scanner = serial.Serial(**ClientTools.get_port_value("Scanner", 115200, 'COM4', 30))
    except Exception as e:
        logger.warn(("init_scanner ERROR :", e))


def start_stop_scanner():
    global start
    try:
        if start:
            start = False
        get_scanner().write((0xFF, 0x55, 0x0D))
        get_scanner().flushInput()
    except Exception as e:
        logger.warn(("start_stop_scanner ERROR :", e))


start = False


def start_get_text_info(zip_flag=False):
    global start
    if not start:
        start = True
        ClientTools.get_global_pool().apply_async(get_text_info, (zip_flag,))


def get_text_info(zip_flag):
    global start
    try:
        get_scanner().flushInput()
        get_scanner().write((0xFF, 0x54, 0x0D))
        scanner_result = get_scanner().readline()
        if scanner_result == b'':
            return
        logger.debug(("pre scanner_result is :", scanner_result))
        logger.debug(("zip_flag is : ", zip_flag))
        if zip_flag:
            scanner_result = base64.b64decode(scanner_result)
            scanner_result = zlib.decompress(scanner_result, 16 + zlib.MAX_WBITS)
        result = str(scanner_result, encoding='utf-8')
        result = result.strip().strip('\r\n').strip('\n')
        logger.debug(("scanner_result is :", result))
        fomart = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-|abcdefghijklmnopqrstuvwxyz'
        for c in result:
            if c not in fomart:
                result = result.replace(c, '')
        logger.info(("change after result:", result))
        scanner_signal_handler.barcode_result.emit(result)
    except Exception as e:
        logger.warn(("scanner get_text_info ERROR :", e))
        scanner_signal_handler.barcode_result.emit("ERROR")
    finally:
        start = False
