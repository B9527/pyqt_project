import os
import zipfile
import datetime
import sys
import shutil
import ClientTools
import logging

__author__ = 'victor.choi@pakpobox.com'
__name__ = 'UploadService'
logger = logging.getLogger()


def start_zip_log_file():
    ClientTools.get_global_pool().apply_async(zip_log_file)


def zip_log_file():
    try:
        log_file = get_log_files()
        if log_file is False:
            return
        else:
            try:
                compression = zipfile.ZIP_DEFLATED
            except:
                compression = zipfile.ZIP_STORED
            path = "log/"
            filename = log_file + '.zip'
            z = zipfile.ZipFile(filename, mode="w", compression=compression)
            try:
                z_path = os.path.join(path, log_file)
                z.write(z_path)
                z.close()
            except:
                if z:
                    z.close()
            remove_zip_file(filename)
    except Exception as e:
        logger.warn("zip_log_file ERROR:", e)


def remove_zip_file(filename):
    if os.path.exists(os.path.join(sys.path[0], filename)):
        shutil.copy(os.path.join(sys.path[0], filename), os.path.join(os.path.join(sys.path[0], 'log'), filename))
        os.remove(os.path.join(sys.path[0], filename))
        os.remove(os.path.join(os.path.join(sys.path[0], 'log'), 'base.log.' + get_pre_date_time()))
    else:
        return


def get_log_files():
    if not os.path.exists(sys.path[0] + "/log"):
        return False
    else:
        files = os.listdir(sys.path[0] + "/log")
        pre_day = get_pre_date_time()
        for file in files:
            file_date = file.split('.')[-1]
            if file_date == pre_day:
                return file
        return False


def get_pre_date_time():
    today = datetime.datetime.now()
    pre_today = today + datetime.timedelta(days=-1)
    return pre_today.strftime('%Y-%m-%d')


def get_date_time():
    today = datetime.datetime.now()
    return today.strftime('%Y-%m-%d')
