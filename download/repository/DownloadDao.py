from database import ClientDatabase

__author__ = 'ChengChen'


def insert_download_info(advertisement):
    sql = "INSERT INTO Download (id, url, filename, status, position, type, MD5,flagTime,version,initFlag,deleteFlag)" \
          "VALUES (:id,:url,:filename,:status,:position, :type,:MD5,:flagTime,:version,:initFlag,:deleteFlag)"
    ClientDatabase.insert_or_update_database(sql, advertisement)


def update_download_info_start(param):
    sql = "UPDATE Download SET status=:status,startTime=:startTime WHERE id=:id"
    ClientDatabase.insert_or_update_database(sql, param)


def update_download_info_end(param):
    sql = "UPDATE Download SET status=:status,EndTime=:endTime WHERE id=:id"
    ClientDatabase.insert_or_update_database(sql, param)


def update_download_info_status(param):
    sql = "UPDATE Download SET status=:status WHERE id=:id"
    ClientDatabase.insert_or_update_database(sql, param)


def get_all_download_info(param):
    sql = "SELECT * FROM Download WHERE status=:status"
    return ClientDatabase.get_result_set(sql, param)


def get_download_info(param):
    sql = "SELECT * FROM Download WHERE status=:status AND type=:type AND flagTime=:flagTime"
    return ClientDatabase.get_result_set(sql, param)


def get_not_finish_info(param):
    sql = "SELECT * FROM Download WHERE status!=:status AND type=:type AND flagTime=:flagTime"
    return ClientDatabase.get_result_set(sql, param)


def get_md5_by_id(param):
    sql = "SELECT MD5 FROM Download WHERE id=:id"
    return ClientDatabase.get_result_set(sql, param)


def check_download_by_id(param):
    sql = "SELECT * FROM Download WHERE id=:id"
    return ClientDatabase.get_result_set(sql, param)


def get_upgrade_info(param):
    sql = "SELECT * FROM Download WHERE type=:type and status =:status AND deleteFlag=0"
    return ClientDatabase.get_result_set(sql, param)


def update_upgrade_info_for_deleteflag(param):
    sql = "UPDATE Download SET deleteFlag=1 WHERE id=:id"
    ClientDatabase.insert_or_update_database(sql, param)
