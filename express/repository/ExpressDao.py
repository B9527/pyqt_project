# coding:utf-8
from database import ClientDatabase

__author__ = 'gaoyang'


def init_express(express):
    sql = "INSERT INTO Express (id, expressNumber, expressType, overdueTime, status, storeTime, syncFlag" \
          ", takeUserPhoneNumber, storeUserPhoneNumber, validateCode, version, box_id, " \
          "logisticsCompany_id, mouth_id, operator_id, " \
          "storeUser_id,groupName,customerStoreNumber, chargeType, continuedHeavy, " \
          "continuedPrice, endAddress, startAddress, firstHeavy, firstPrice, designationSize, " \
          "electronicCommerce_id, takeUser_id, payAmount, payType, order_id)" \
          "VALUES (:id,:expressNumber,:expressType,:overdueTime,:status,:storeTime,:syncFlag,:takeUserPhoneNumber" \
          ",:storeUserPhoneNumber,:validateCode,:version,:box_id,:logisticsCompany_id,:mouth_id,:operator_id,:" \
          "storeUser_id,:groupName,:customerStoreNumber,:chargeType,:continuedHeavy,:continuedPrice" \
          ",:endAddress,:startAddress,:firstHeavy,:firstPrice,:designationSize,:electronicCommerce_id" \
          ",:takeUser_id,:payAmount,:payType,:order_id)"
    ClientDatabase.insert_or_update_database(sql, express)


def get_express_by_id_and_validate(param):
    sql = "SELECT * FROM Express WHERE id = :id AND ValidateCode = :validateCode AND Status=:status"
    return ClientDatabase.get_result_set(sql, param)


def take_express(param):
    sql = "UPDATE express SET TakeTime=:takeTime,SyncFlag = :syncFlag,Version = :version,Status = :status," \
          "staffTakenUser_id=:staffTakenUser_id, lastModifiedTime=:lastModifiedTime" \
          " WHERE id=:id"
    ClientDatabase.insert_or_update_database(sql, param)


def get_express_by_validate(param):
    sql = "SELECT * FROM Express WHERE ValidateCode=:validateCode AND Status=:status"
    return ClientDatabase.get_result_set(sql, param)


def get_take_aID_by_validate(param):
    sql = "SELECT expressNumber FROM Express WHERE ValidateCode=:validateCode AND Status=:status"
    return ClientDatabase.get_result_set(sql, param)


def save_express(express_param):
    sql = "INSERT INTO Express (id, ExpressNumber, expressType,  status, StoreTime, SyncFlag" \
          ", ValidateCode, Version, box_id, mouth_id" \
          ", operator_id, groupName, lastModifiedTime, payAmount, payType, order_id, takeUser_id)" \
          " VALUES (:id,:expressNumber,:expressType,:status,:storeTime,:syncFlag," \
          ":validateCode,:version,:box_id,:mouth_id" \
          ",:operator_id,:groupName,:lastModifiedTime,:payAmount,:payType,:order_id,:takeUser_id)"
    ClientDatabase.insert_or_update_database(sql, express_param)
    print("写入本地数据库成功！")


def mark_sync_success(express_param):
    sql = "UPDATE express SET SyncFlag = 1, lastModifiedTime=:lastModifiedTime WHERE id = :id"
    ClientDatabase.insert_or_update_database(sql, express_param)


def update_express(express_param):
    sql = "UPDATE express SET overdueTime=:overdueTime,status=:status,StoreTime=:storeTime,SyncFlag=:syncFlag" \
          ",ValidateCode=:validateCode,box_id=:box_id,logisticsCompany_id=:logisticsCompany_id,mouth_id=:mouth_id" \
          ",operator_id=:operator_id,storeUser_id=:storeUser_id, lastModifiedTime=:lastModifiedTime WHERE id=:id"
    ClientDatabase.insert_or_update_database(sql, express_param)


def import_express(express_param__):
    sql = "INSERT INTO Express (id,ExpressNumber,expressType,TakeUserPhoneNumber,Version,SyncFlag,lastModifiedTime)" \
          "VALUES (:id,:expressNumber,:expressType,:takeUserPhoneNumber,:version,:syncFlag,:lastModifiedTime)"
    ClientDatabase.insert_or_update_database(sql, express_param__)


def update_recode(record):
    sql = "UPDATE TransactionRecord SET Amount=:amount WHERE express_id = :express_id"
    ClientDatabase.insert_or_update_database(sql, record)


def get_record(record_param):
    sql = "SELECT * FROM TransactionRecord WHERE express_id = :express_id"
    return ClientDatabase.get_result_set(sql, record_param)


def save_record(record_param):
    sql = "INSERT INTO TransactionRecord (id, paymentType, transactionType, Amount, express_id, CreateTime)" \
          "VALUES (:id,:paymentType,:transactionType,:amount,:express_id,:createTime)"
    ClientDatabase.insert_or_update_database(sql, record_param)


def get_overdue_express_by_logistics_id(param):
    sql = "SELECT * FROM Express " \
          "WHERE logisticsCompany_id = :logisticsCompany_id AND status =:status AND overdueTime < :overdueTime " \
          "AND expressType =:expressType ORDER BY overdueTime DESC LIMIT :startLine,5 "
    return ClientDatabase.get_result_set(sql, param)


def get_overdue_express_by_manager(param):
    sql = "SELECT * FROM Express " \
          "WHERE status =:status AND overdueTime < :overdueTime " \
          "AND expressType =:expressType ORDER BY overdueTime DESC LIMIT :startLine,5 "
    return ClientDatabase.get_result_set(sql, param)


def get_all_overdue_express_by_logistics_id(param):
    sql = "SELECT * FROM Express " \
          "WHERE logisticsCompany_id = :logisticsCompany_id AND status =:status AND expressType =:expressType " \
          "AND overdueTime < :overdueTime " \
          "ORDER BY overdueTime DESC"
    return ClientDatabase.get_result_set(sql, param)


def get_all_overdue_express_by_manager(param):
    sql = "SELECT * FROM Express " \
          "WHERE status =:status AND overdueTime < :overdueTime AND expressType =:expressType " \
          "ORDER BY overdueTime DESC"
    return ClientDatabase.get_result_set(sql, param)


def get_in_store_overdue_express_by_over_time_and_operator_id_and_start_line(param):
    sql = "SELECT * FROM Express " \
          "WHERE operator_id = :operator_id AND status =:status AND overdueTime < :overdueTime " \
          "ORDER BY overdueTime DESC LIMIT :startLine,5 "
    return ClientDatabase.get_result_set(sql, param)


def get_overdue_express_count_by_logistics_id(param):
    sql = "SELECT count(1) AS count FROM Express " \
          "WHERE logisticsCompany_id = :logisticsCompany_id AND status =:status AND overdueTime < :overdueTime " \
          "AND expressType =:expressType"
    return ClientDatabase.get_result_set(sql, param)


def get_overdue_express_count_by_manager(param):
    sql = "SELECT count(1) AS count FROM Express " \
          "WHERE status =:status AND overdueTime <:overdueTime AND expressType =:expressType"
    return ClientDatabase.get_result_set(sql, param)


def get_express_by_id(param):
    sql = "SELECT * FROM Express WHERE id=:id"
    return ClientDatabase.get_result_set(sql, param)


def get_not_sync_express_list(param):
    sql = "SELECT * FROM Express WHERE syncFlag=:syncFlag"
    return ClientDatabase.get_result_set(sql, param)


def save_customer_express(customer_store_express):
    sql = "INSERT INTO Express(id, customerStoreNumber, expressType," \
          " status, storeTime, syncFlag, version, " \
          "box_id, logisticsCompany_id, mouth_id, operator_id, " \
          "storeUser_id, recipientName, weight, recipientUserPhoneNumber, chargeType, lastModifiedTime,)" \
          "VALUES (:id,:customerStoreNumber,:expressType," \
          "'IN_STORE',:storeTime,0,0,:box_id," \
          ":logisticsCompany_id,:mouth_id,:operator_id," \
          ":storeUser_id,:recipientName,:weight,:recipientUserPhoneNumber, :chargeType, :lastModifiedTime,)"
    return ClientDatabase.save_customer_express(sql, customer_store_express)


def save_customer_reject_express(customer_store_express):
    sql = "INSERT INTO Express(id, customerStoreNumber, expressType," \
          " status, storeTime, syncFlag, version, electronicCommerce_id, " \
          "box_id, logisticsCompany_id, mouth_id, operator_id, " \
          "storeUser_id, recipientName, weight, storeUserPhoneNumber, chargeType, lastModifiedTime)" \
          "VALUES (:id,:customerStoreNumber,:expressType," \
          "'IN_STORE',:storeTime,0,0,:electronicCommerce_id,:box_id," \
          ":logisticsCompany_id,:mouth_id,:operator_id," \
          ":storeUser_id,:recipientName,:weight,:storeUserPhoneNumber, :chargeType,:lastModifiedTime)"
    return ClientDatabase.insert_or_update_database(sql, customer_store_express)


def get_send_express_count_by_logistics_id(param):
    sql = "SELECT count(1) AS count FROM Express " \
          "WHERE logisticsCompany_id = :logisticsCompany_id AND Express.status =:status AND expressType =:expressType "
    return ClientDatabase.get_result_set(sql, param)


def get_send_express_count_by_operator(param):
    sql = "SELECT count(1) AS count FROM Express " \
          "WHERE Express.status =:status AND expressType =:expressType "
    return ClientDatabase.get_result_set(sql, param)


def get_send_express_by_logistics_id(param):
    sql = "SELECT * FROM Express " \
          "WHERE logisticsCompany_id = :logisticsCompany_id AND status =:status AND expressType =:expressType " \
          "ORDER BY storeTime LIMIT :startLine,5 "
    return ClientDatabase.get_result_set(sql, param)


def get_send_express_by_operator(param):
    sql = "SELECT * FROM Express " \
          "WHERE status =:status AND expressType =:expressType " \
          "ORDER BY storeTime LIMIT :startLine,5 "
    return ClientDatabase.get_result_set(sql, param)


def get_all_send_express_by_logistics_id(param):
    sql = "SELECT * FROM Express " \
          "WHERE logisticsCompany_id = :logisticsCompany_id AND status =:status AND expressType =:expressType " \
          "ORDER BY storeTime "
    return ClientDatabase.get_result_set(sql, param)


def get_all_send_express_by_manager(param):
    sql = "SELECT * FROM Express " \
          "WHERE status =:status AND expressType =:expressType " \
          "ORDER BY storeTime "
    return ClientDatabase.get_result_set(sql, param)


def get_mouth(express__):
    sql = "SELECT * FROM TransactionRecord " \
          "WHERE express_id = :id"
    return ClientDatabase.get_result_set(sql, express__)


def save_express_for_customer_to_staff(express_param):
    sql = "INSERT INTO Express (id, expressType, overdueTime, status, StoreTime, SyncFlag" \
          ", Version, box_id, mouth_id" \
          ", operator_id, storeUser_id,groupName,lastModifiedTime)" \
          " VALUES (:id,:expressType,:overdueTime,:status,:storeTime,:syncFlag," \
          ":version,:box_id,:mouth_id" \
          ",:operator_id,:storeUser_id,:groupName,:lastModifiedTime)"
    ClientDatabase.insert_or_update_database(sql, express_param)


def save_send_express(express_param):
    sql = "INSERT INTO Express (id, customerStoreNumber, expressType, overdueTime, status, storeTime, syncFlag" \
          ", version, box_id, mouth_id, storeUserPhoneNumber" \
          ", operator_id, groupName,Weight, lastModifiedTime)" \
          " VALUES (:id,:customerStoreNumber,:expressType,:overdueTime,:status,:storeTime,:syncFlag," \
          ":version,:box_id,:mouth_id,:storeUserPhoneNumber" \
          ",:operator_id,:groupName,:Weight,:lastModifiedTime)"
    ClientDatabase.insert_or_update_database(sql, express_param)


def get_express_by_express_type(param):
    sql = "SELECT * FROM Express WHERE expressType=:expressType AND status=:status"
    return ClientDatabase.get_result_set(sql, param)


def staff_get_send_express_by_logistics_id(param):
    sql = "SELECT * FROM Express " \
          "WHERE status =:status AND expressType =:expressType " \
          "ORDER BY storeTime LIMIT :startLine,5 "
    return ClientDatabase.get_result_set(sql, param)


def reset_express(param):
    sql = "UPDATE express SET overdueTime =:overdueTime, status =:status, syncFlag =:syncFlag" \
          ", takeUserPhoneNumber =:takeUserPhoneNumber, validateCode =:validateCode, version =:version" \
          ", lastModifiedTime=:lastModifiedTime" \
          " WHERE id =:id"
    return ClientDatabase.insert_or_update_database(sql, param)


def get_holiday_info(param):
    sql = "SELECT * FROM Holiday WHERE deleteFlag = 0 AND holidayType =:holidayType"
    return ClientDatabase.get_result_set(sql, param)
