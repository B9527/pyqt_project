import json
import logging
import os
import time

from PyQt5.QtCore import QObject, pyqtSignal
import sys
import ClientTools

__author__ = 'victor.choi'


class AdSignalHandler(QObject):
    ad_source_signal = pyqtSignal(str)
    ad_source_number_signal = pyqtSignal(str)


logger = logging.getLogger()
ad_signal_handler = AdSignalHandler()


def start_get_ad_file():
    ClientTools.get_global_pool().apply_async(get_ad_file,)


def get_ad_file():
    file_path = sys.path[0] + "/advertisement/source/"
    ad_file = {}
    if os.path.isdir(file_path):
        for key in range(0, len(os.listdir(file_path))):
            ad_file[key] = os.listdir(file_path)[key]
    ad_signal_handler.ad_source_signal.emit(json.dumps(ad_file))
    ad_signal_handler.ad_source_number_signal.emit(str(len(ad_file)))
