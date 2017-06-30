import logging
from company.repository import CompanyDao
import box.service.BoxService


__author__ = 'gaoyang'
logger = logging.getLogger()


def init_company(param):
    try:
        company = {'id': param['id'], 'companyType': param['companyType'], 'name': param['name'],
                   'deleteFlag': param['deleteFlag']}
        if 'parentCompany' in param:
            company['parentCompany_id'] = param['parentCompany']['id']
            init_company(param['parentCompany'])
        else:
            company['parentCompany_id'] = None
        CompanyDao.init_company(company)
    except Exception as e:
        logger.error(("init_company ERROR :", e))
        box.service.BoxService.BoxSignalHandler.init_client_signal.emit("ERROR")


def get_company_by_id(param):
    company_param = {"id": param}
    company_list = CompanyDao.get_company_by_id(company_param)
    if len(company_list) != 1:
        return False
    return company_list[0]
