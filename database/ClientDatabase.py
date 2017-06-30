import logging
import os
import sys
import threading
import time
import shutil
import sqlite3
# import box.service.BoxService

__author__ = 'gaoyang'


lock = threading.Lock()
logger = logging.getLogger()


def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return dict((k, v) for k, v in d.items() if v is not None)


def get_conn():
    conn = sqlite3.connect(sys.path[0] + "/database/pakpobox.db")
    conn.row_factory = dict_factory
    return conn


def get_result_set(sql, parameter):
    try:
        lock.acquire()
        logger.info((sql, parameter))
        conn__ = get_conn()
        cursor = conn__.cursor().execute(sql, parameter)
        result = cursor.fetchall()
        logger.info(result)
    finally:
        lock.release()
    return result


def insert_or_update_database(sql, parameter):
    try:
        lock.acquire()
        logger.info((sql, parameter))
        conn__ = get_conn()
        conn__.execute(sql, parameter)
        conn__.commit()
    finally:
        lock.release()


def init_database():
    try:
        if os.path.isfile(os.path.join(sys.path[0] + "/database/", "pakpobox.db")) is True:
            shutil.copyfile(os.path.join(sys.path[0] + "/database/", "pakpobox.db"),
                            os.path.join(sys.path[0] + "/database/",
                                         "pakpobox" + time.strftime('%y%m%d%H%M%S', time.localtime()) + ".db"))
        conn__ = get_conn()
        with open(sys.path[0] + '/database/ClientDatabase.sql') as f:
            conn__.cursor().executescript(f.read())
    except Exception as e:
        logger.warn(("init_database ERROR", e))


if __name__ == '__main__':
    __conn = sqlite3.connect("pakpobox.db")
    with open('ClientDatabase.sql') as f:
        __conn.cursor().executescript(f.read())
