from database import ClientDatabase

__author__ = 'gaoyang'


def init_company(param):
    sql = "INSERT INTO Company (id, companyType, name, parentCompany_id,deleteFlag)" \
          "VALUES (:id,:companyType,:name,:parentCompany_id,:deleteFlag)"
    ClientDatabase.insert_or_update_database(sql, param)


def get_company_by_id(company_param):
    sql = "SELECT * FROM Company WHERE id = :id"
    return ClientDatabase.get_result_set(sql, company_param)


def insert_company(param):
    sql = "INSERT INTO Company (id, companyType, name, parentCompany_id,deleteFlag)" \
          "VALUES (:id,:companyType,:name,:parentCompany_id,:deleteFlag)"
    ClientDatabase.insert_or_update_database(sql, param)


def update_company(param):
    sql = "UPDATE Company SET companyType =:companyType, name =:name, parentCompany_id =:parentCompany_id," \
          "deleteFlag =:deleteFlag WHERE id =:id"
    ClientDatabase.insert_or_update_database(sql, param)
