from database import ClientDatabase

__author__ = 'gaoyang'


def insert_alert_info(ups_parm):
    sql = "INSERT INTO Alert (id, alertType, alertStatus, createTime, box_id, syncFlag,operator_id,alertvalue," \
          "value_id) VALUES (:id, :alertType, :alertStatus, :createTime, :box_id, :syncFlag, :operator_id," \
          " :alertvalue,:value_id)"
    ClientDatabase.insert_or_update_database(sql, ups_parm)


def check_alert_status(ups_parm):
    sql = "SELECT * FROM Alert WHERE alertType = :alertType ORDER BY createTime DESC "
    return ClientDatabase.get_result_set(sql, ups_parm)


def check_not_sync(param):
    sql = "SELECT * FROM Alert WHERE SyncFlag = 0 ORDER BY createTime DESC "
    return ClientDatabase.get_result_set(sql, param)


def mark_alert_sync_success(ups_parm):
    sql = "UPDATE Alert SET SyncFlag = 1 WHERE id = :id"
    ClientDatabase.insert_or_update_database(sql, ups_parm)


def check_alert_by_alertvalue(param):
    sql = "SELECT * FROM Alert WHERE alertvalue = :alertvalue AND alertType =:alertType ORDER BY createTime DESC "
    return ClientDatabase.get_result_set(sql, param)


def check_alert_by_value_id(param):
    sql = "SELECT * FROM Alert WHERE value_id = :value_id AND alertType =:alertType ORDER BY createTime DESC "
    return ClientDatabase.get_result_set(sql, param)
