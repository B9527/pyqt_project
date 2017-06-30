from database import ClientDatabase

__author__ = 'gaoyang'


def get_mouth(msg):
    sql = "SELECT * FROM Mouth WHERE express_id = :id"
    return ClientDatabase.get_result_set(sql, msg)[0]


def init_box(msg):
    sql = "INSERT INTO Box (id, deleteFlag, name, orderNo, operator_id,validateType," \
          "syncFlag,currencyUnit,overdueType,freeDays,freeHours,receiptNo,holidayType) " \
          "VALUES (:id,0,:name,:orderNo,:operator_id,:validateType," \
          ":syncFlag,:currencyUnit,:overdueType,:freeDays,:freeHours,:receiptNo,:holidayType)"
    ClientDatabase.insert_or_update_database(sql, msg)


def init_holiday(param):
    sql = "INSERT INTO Holiday (id, startTime, endTime, delayDay, holidayType, deleteFlag) " \
          "VALUES (:id,:startTime,:endTime,:delayDay,:holidayType,0)"
    ClientDatabase.insert_or_update_database(sql, param)


def update_holiday(msg):
    sql = "UPDATE Holiday SET startTime=:startTime, endTime=:endTime," \
          "delayDay=:delayDay,holidayType=:holidayType WHERE id=:id"
    ClientDatabase.insert_or_update_database(sql, msg)


def get_holiday_by_id(param):
    sql = "SELECT * FROM Holiday WHERE deleteFlag = 0 AND id = :id"
    return ClientDatabase.get_result_set(sql, param)


def delete_holiday(param):
    sql = "UPDATE Holiday SET deleteFlag= 1 WHERE id=:id"
    ClientDatabase.insert_or_update_database(sql, param)


def update_box(msg):
    sql = "UPDATE Box SET name=:name, orderNo=:orderNo," \
          "validateType=:validateType,currencyUnit=:currencyUnit,overdueType=:overdueType," \
          "freeDays=:freeDays,freeHours=:freeHours,holidayType=:holidayType WHERE id=:id"
    ClientDatabase.insert_or_update_database(sql, msg)


def init_cabinet(cabinet):
    sql = "INSERT INTO Cabinet(id, deleteFlag, number)" \
          "VALUES (:id,:deleteFlag,:number)"
    ClientDatabase.insert_or_update_database(sql, cabinet)


def init_mouth(mouth):
    sql = "INSERT INTO Mouth(id, deleteFlag, number,usePrice ,overduePrice, status, box_id, cabinet_id, " \
          "express_id, mouthType_id,numberInCabinet,syncFlag,openOrder)" \
          "VALUES (:id,:deleteFlag,:number,:usePrice,:overduePrice,:status,:box_id,:cabinet_id,:express_id" \
          ",:mouthType_id,:numberInCabinet,:syncFlag,:openOrder)"
    ClientDatabase.insert_or_update_database(sql, mouth)


def init_mouth_type(mouth_type):
    sql = "SELECT * FROM MouthType WHERE id=:id"
    result_set = ClientDatabase.get_result_set(sql, mouth_type)
    if len(result_set) != 0:
        return
    sql = "INSERT INTO MouthType (id, defaultUsePrice,defaultOverduePrice, name,deleteFlag)" \
          "VALUES (:id,:defaultUsePrice,:defaultOverduePrice,:name,:deleteFlag)"
    ClientDatabase.insert_or_update_database(sql, mouth_type)


def free_mouth(mouth):
    sql = "UPDATE mouth SET express_id = NULL , status = 'ENABLE' " \
          "WHERE id = :id"
    ClientDatabase.insert_or_update_database(sql, mouth)


def get_mouth_type(mouth_type_param):
    sql = "SELECT * FROM MouthType WHERE name = :name AND deleteFlag = 0"
    return ClientDatabase.get_result_set(sql, mouth_type_param)


def get_free_mouth_by_type(mouth_param):
    sql = "SELECT * FROM Mouth WHERE mouthType_id=:mouthType_id AND deleteFlag = :deleteFlag AND status = :status " \
          "LIMIT 0,1"
    return ClientDatabase.get_result_set(sql, mouth_param)


def get_free_mouth_by_type_enable(mouth_param):
    sql = "SELECT * FROM Mouth WHERE  deleteFlag = :deleteFlag AND status = :status " \
          "LIMIT 0,1"
    return ClientDatabase.get_result_set(sql, mouth_param)


def get_box_by_order_no(order_no):
    sql = "SELECT * FROM Box WHERE orderNo = :orderNo AND deleteFlag = :deleteFlag"
    return ClientDatabase.get_result_set(sql, order_no)


def get_box_by_box_id(box_id):
    sql = "SELECT * FROM Box WHERE id = :id AND deleteFlag = :deleteFlag"
    return ClientDatabase.get_result_set(sql, box_id)


def use_mouth(mouth_param__):
    sql = "UPDATE mouth SET express_id=:express_id ,Status=:status WHERE id = :id"
    ClientDatabase.insert_or_update_database(sql, mouth_param__)


def get_mouth_by_id(mouth_param):
    sql = "SELECT * FROM Mouth WHERE id = :id"
    return ClientDatabase.get_result_set(sql, mouth_param)


def get_cabinet_by_id(param):
    sql = "SELECT * FROM Cabinet WHERE id=:id"
    return ClientDatabase.get_result_set(sql, param)


def get_free_mouth_count_by_mouth_type_name(param):
    sql = "SELECT count(1) AS count " \
          "FROM Mouth  INNER JOIN MouthType " \
          "ON Mouth.mouthType_id = MouthType.id AND Mouth.status = :status AND MouthType.name = :name"
    return ClientDatabase.get_result_set(sql, param)


def update_free_time(param):
    sql = "UPDATE Box SET freeHours=:freeHours,freeDays=:freeDays,overdueType=:overdueType WHERE id=:id"
    ClientDatabase.insert_or_update_database(sql, param)


def update_mouth_status(param):
    sql = "UPDATE mouth SET status=:status WHERE id=:id "
    ClientDatabase.insert_or_update_database(sql, param)


def get_mouth_list(param):
    sql = "SELECT mouth.id, mouth.deleteFlag, Mouth.number, Mouth.syncFlag, Mouth.status, MouthType.name " \
          "FROM Mouth INNER JOIN MouthType " \
          "ON Mouth.mouthType_id = MouthType.id AND Mouth.deleteFlag = :deleteFlag " \
          "ORDER BY Mouth.number LIMIT :startLine,25 "
    return ClientDatabase.get_result_set(sql, param)


def get_all_mouth(param):
    sql = "SELECT * FROM Mouth WHERE deleteFlag=:deleteFlag ORDER BY Mouth.number"
    return ClientDatabase.get_result_set(sql, param)


def get_all_mouth_count(param):
    sql = "SELECT count(1) AS count FROM Mouth WHERE deleteFlag = :deleteFlag"
    return ClientDatabase.get_result_set(sql, param)


def manage_set_mouth(param):
    sql = "UPDATE mouth SET status=:status, syncFlag=:syncFlag WHERE id=:id "
    return ClientDatabase.insert_or_update_database(sql, param)


def mark_sync_success(param):
    sql = "UPDATE mouth SET syncFlag = 1 WHERE id = :id"
    ClientDatabase.insert_or_update_database(sql, param)


def mark_box_sync_success(param):
    sql = "UPDATE Box SET syncFlag = 1"
    ClientDatabase.insert_or_update_database(sql, param)


def get_all_mouth_type(param):
    sql = "SELECT * FROM MouthType WHERE deleteFlag = :deleteFlag"
    return ClientDatabase.get_result_set(sql, param)


def get_count_by_status_and_mouth_type_id(param):
    sql = "SELECT count(1) AS mouth_count FROM Mouth WHERE status=:status AND mouthType_id=:mouthType_id " \
          "AND deleteFlag=:deleteFlag"
    return ClientDatabase.get_result_set(sql, param)


def get_not_sync_mouth_list(param):
    sql = "SELECT * FROM Mouth WHERE deleteFlag=0 AND syncFlag=:syncFlag"
    return ClientDatabase.get_result_set(sql, param)


def get_free_mouth_by_id(param):
    sql = "SELECT * FROM Mouth WHERE deleteFlag=0 AND id=:id AND status =:status"
    return ClientDatabase.get_result_set(sql, param)
