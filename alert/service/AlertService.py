import ClientTools
from alert.repository import AlertDao
import box.service.BoxService
from network import HttpClient
import logging

__author__ = 'victor.choi@pakpobox.com'
logger = logging.getLogger()


def start_alert_abnormal(alert_type, alert_value, value_id=None):
    ClientTools.get_global_pool().apply_async(alert_abnormal, (alert_type, alert_value, value_id,))


def alert_abnormal(alert_type, alert_value, value_id=None):
    try:
        logger.debug(
            "abnormal alert_type is :" + alert_type + "; alert_value is :" + alert_value)
        if value_id is None:
            param = {"alertType": alert_type, "alertvalue": alert_value}
            result = AlertDao.check_alert_by_alertvalue(param)
        else:
            param = {"alertType": alert_type, "value_id": value_id}
            result = AlertDao.check_alert_by_value_id(param)
        if len(result) > 0:
            alert_status = result[0]["alertStatus"]
            if alert_status == "RECOVERY":
                box_info = box.service.BoxService.get_box()
                param = {"alertType": alert_type, "alertStatus": "ABNORMAL",
                         "createTime": ClientTools.now(),
                         "id": ClientTools.get_uuid(), "operator_id": box_info["operator_id"], "syncFlag": 0,
                         "box_id": box_info["id"], "alertvalue": alert_value, "value_id": value_id}
                AlertDao.insert_alert_info(param)

                param["box"] = box_info
                param["operator"] = {"id": box_info["operator_id"]}
                message, status_code = HttpClient.post_message("alert/create", param)
                if status_code == 200:
                    AlertDao.mark_alert_sync_success(param)
                else:
                    logger.warning(message)
        if len(result) == 0:
            box_info = box.service.BoxService.get_box()
            param = {"alertType": alert_type, "alertStatus": "ABNORMAL", "createTime": ClientTools.now(),
                     "id": ClientTools.get_uuid(), "operator_id": box_info["operator_id"], "syncFlag": 0,
                     "box_id": box_info["id"], "alertvalue": alert_value, "value_id": value_id}
            AlertDao.insert_alert_info(param)

            param["box"] = box_info
            param["operator"] = {"id": box_info["operator_id"]}
            message, status_code = HttpClient.post_message("alert/create", param)
            if status_code == 200:
                AlertDao.mark_alert_sync_success(param)
            else:
                logger.warning(message)
    except Exception as e:
        logger.error(("alert_abnormal ERROR :", e))


def start_alert_recovery(alert_type, alert_value, value_id=None):
    ClientTools.get_global_pool().apply_async(alert_recovery, (alert_type, alert_value, value_id,))


def alert_recovery(alert_type, alert_value, value_id=None):
    try:
        logger.debug(
            "recovery alert_type is :" + alert_type + "; alert_value is :" + alert_value)
        if value_id is None:
            param = {"alertType": alert_type, "alertvalue": alert_value}
            result = AlertDao.check_alert_by_alertvalue(param)
        else:
            param = {"alertType": alert_type, "value_id": value_id}
            result = AlertDao.check_alert_by_value_id(param)
        if len(result) > 0:
            alert_status = result[0]["alertStatus"]
            if alert_status == "ABNORMAL":
                box_info = box.service.BoxService.get_box()
                recovery_param = {"alertType": alert_type, "alertStatus": "RECOVERY",
                                  "createTime": ClientTools.now(),
                                  "id": ClientTools.get_uuid(), "operator_id": box_info["operator_id"],
                                  "syncFlag": 0,
                                  "box_id": box_info["id"], "alertvalue": alert_value, "value_id": value_id}
                AlertDao.insert_alert_info(recovery_param)

                recovery_param["box"] = box_info
                recovery_param["operator"] = {"id": box_info["operator_id"]}
                message, status_code = HttpClient.post_message("alert/create", recovery_param)
                if status_code == 200:
                    AlertDao.mark_alert_sync_success(recovery_param)
                else:
                    logger.warning(message)
    except Exception as e:
        logger.error(("alert_recovery ERROR :", e))


def system_closed_alert():
    try:
        logger.warn("system_closed_alert !!!")
        box_info = box.service.BoxService.get_box()
        recovery_param = {"alertType": "SYSTEM_CLOSED", "alertStatus": "ABNORMAL",
                          "createTime": ClientTools.now(),
                          "id": ClientTools.get_uuid(), "operator_id": box_info["operator_id"],
                          "syncFlag": 0,
                          "box_id": box_info["id"], "alertvalue": box_info["name"], "value_id": None}
        AlertDao.insert_alert_info(recovery_param)

        recovery_param["box"] = box_info
        recovery_param["operator"] = {"id": box_info["operator_id"]}
        message, status_code = HttpClient.post_message("alert/create", recovery_param)
        if status_code == 200:
            AlertDao.mark_alert_sync_success(recovery_param)
        else:
            logger.warning(message)
    except Exception as e:
        logger.error(("system_closed_alert ERROR :", e))


def main_box_open_alert():
    try:
        logger.warn("main_box_open_alert !!!")
        box_info = box.service.BoxService.get_box()
        recovery_param = {"alertType": "CONSOLE_OPEN", "alertStatus": "ABNORMAL",
                          "createTime": ClientTools.now(),
                          "id": ClientTools.get_uuid(), "operator_id": box_info["operator_id"],
                          "syncFlag": 0,
                          "box_id": box_info["id"], "alertvalue": box_info["name"], "value_id": None}
        AlertDao.insert_alert_info(recovery_param)

        recovery_param["box"] = box_info
        recovery_param["operator"] = {"id": box_info["operator_id"]}
        message, status_code = HttpClient.post_message("alert/create", recovery_param)
        if status_code == 200:
            AlertDao.mark_alert_sync_success(recovery_param)
        else:
            logger.warning(message)
    except Exception as e:
        logger.error(("main_box_open_alert ERROR :", e))
