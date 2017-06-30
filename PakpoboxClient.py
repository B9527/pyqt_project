import os
import sys

from PyQt5.QtCore import QUrl, QObject, pyqtSlot, QTranslator, Qt
from PyQt5.QtQuick import QQuickView
from PyQt5.Qt import QGuiApplication
import pygame
import wmi
from advertisement.service import AdvertisermentService

from box.service import BoxService
from download.service import DownloadService
from database import ClientDatabase
from device import Camera
from express.service import ExpressService
from music.service import MusicService
from network import HttpClient
from sync import PushMessage, PullMessage
from user.service import UserService
from alert.service import AlertService
import logging
import logging.handlers


class SlotHandler(QObject):
    @pyqtSlot(str)
    def select_language(self, string):
        translator.load(path + string)

    @pyqtSlot()
    def start_get_version(self):
        BoxService.start_get_version()

    @pyqtSlot()
    def clean_user_token(self):
        HttpClient.clean_user_token()

    @pyqtSlot()
    def in_main_page(self):
        PushMessage.main_page_flag = True

    @pyqtSlot()
    def quit_main_page(self):
        PushMessage.main_page_flag = False

    @pyqtSlot(str)
    def customer_take_express(self, string):
        ExpressService.start_customer_take_express(string)

    @pyqtSlot()
    def customer_take_express_disks_check(self):
        ExpressService.start_customer_take_express_disks()

    @pyqtSlot()
    def customer_scan_barcode_take_express(self):
        ExpressService.start_barcode_take_express()

    @pyqtSlot()
    def customer_cancel_scan_barcode(self):
        ExpressService.stop_barcode_take_express()

    @pyqtSlot()
    def get_express_mouth_number(self):
        BoxService.get_express_mouth_number()

    @pyqtSlot()
    def start_get_ups_status(self):
        BoxService.start_get_ups_status()

    @pyqtSlot()
    def customer_get_overdue_cost(self):
        ExpressService.get_overdue_cost()

    @pyqtSlot(str, str, str)
    def background_login(self, username, password, identity):
        UserService.background_login_start(username, password, identity)

    @pyqtSlot()
    def start_courier_scan_barcode(self):
        ExpressService.start_get_express_number_by_barcode()

    @pyqtSlot()
    def stop_courier_scan_barcode(self):
        ExpressService.stop_get_express_number_by_barcode()

    @pyqtSlot(str)
    def set_express_number(self, express_number):
        ExpressService.set_express_number(express_number)

    @pyqtSlot(str)
    def set_phone_number(self, phone_number):
        ExpressService.set_phone_number(phone_number)

    @pyqtSlot()
    def start_store_express(self):
        ExpressService.start_store_express()

    @pyqtSlot()
    def start_pay_cash_for_overdue_express(self):
        ExpressService.start_pay_cash_for_overdue_express()

    @pyqtSlot()
    def get_user_info(self):
        UserService.get_user_info()

    @pyqtSlot()
    def manager_get_box_info(self):
        BoxService.start_manager_get_box_info()

    @pyqtSlot(str)
    def start_get_oacheck_info(self, customer_store_number):
        ExpressService.start_get_oacheck_info(customer_store_number)

    @pyqtSlot(str)
    def start_set_username(self, username):
        ExpressService.start_set_username(username)

    @pyqtSlot(str)
    def start_get_about_oainfo(self, customer_store_number):
        ExpressService.start_get_about_oainfo(customer_store_number)

    @pyqtSlot(str)
    def start_get_customer_reject_express_info(self, customer_reject_number):
        ExpressService.start_get_customer_reject_express_info(customer_reject_number)
        # @pyqtSlot()
        # def start_customer_scan_qr_code(self):
        # ExpressService.start_customer_scan_qr_code()
        # @pyqtSlot()
        # def stop_customer_scan_qr_code(self):
        # ExpressService.stop_customer_scan_qr_code()

    @pyqtSlot()
    def start_get_mouth_status(self):
        BoxService.start_get_mouth_status()

    @pyqtSlot()
    def start_get_free_mouth_mun(self):
        BoxService.start_get_free_mouth_mun()

    @pyqtSlot(int)
    def start_courier_load_overdue_express_list(self, page):
        ExpressService.start_courier_load_overdue_express_list(page)

    @pyqtSlot(int)
    def start_manager_load_overdue_express_list(self, page):
        ExpressService.start_manager_load_overdue_express_list(page)

    @pyqtSlot()
    def start_load_courier_overdue_express_count(self):
        ExpressService.start_load_courier_overdue_express_count()

    @pyqtSlot()
    def start_load_manager_overdue_express_count(self):
        ExpressService.start_load_manager_overdue_express_count()

    @pyqtSlot()
    def start_open_mouth_again(self):
        BoxService.start_open_mouth()

    @pyqtSlot()
    def start_init_client(self):
        BoxService.start_init_client()

    @pyqtSlot(str)
    def start_courier_take_overdue_express(self, id_list):
        ExpressService.start_staff_take_overdue_express_list(id_list)

    @pyqtSlot()
    def start_courier_take_overdue_all(self):
        ExpressService.start_staff_take_all_overdue_express()

    @pyqtSlot()
    def start_calculate_customer_express_cost(self):
        ExpressService.start_calculate_customer_express_cost()

    @pyqtSlot()
    def start_calculate_customer_reject_express_cost(self):
        ExpressService.start_calculate_customer_reject_express_cost()

    @pyqtSlot()
    def stop_calculate_customer_express_cost(self):
        ExpressService.stop_calculate_customer_express_cost()

    @pyqtSlot()
    def stop_calculate_customer_reject_express_cost(self):
        ExpressService.stop_calculate_customer_reject_express_cost()

    @pyqtSlot()
    def start_pay_cash_for_customer_express(self):
        ExpressService.start_pay_cash_for_customer_express()

    @pyqtSlot()
    def start_pay_cash_for_customer_reject_express(self):
        ExpressService.start_pay_cash_for_customer_reject_express()

    @pyqtSlot(int)
    def start_pull_pre_pay_cash_for_customer_express(self, express_cost):
        ExpressService.start_pull_pre_pay_cash_for_customer_express(express_cost)

    @pyqtSlot(int)
    def start_pull_pre_pay_cash_for_customer_reject_express(self, express_cost):
        ExpressService.start_pull_pre_pay_cash_for_customer_reject_express(express_cost)

    @pyqtSlot(str)
    def start_free_mouth_by_size(self, mouth_size):
        BoxService.start_free_mouth_by_size(mouth_size)

    @pyqtSlot()
    def stop_pay_cash_for_customer_express(self):
        ExpressService.stop_pay_cash_for_customer_express()

    @pyqtSlot()
    def stop_pay_cash_for_customer_reject_express(self):
        ExpressService.stop_pay_cash_for_customer_reject_express()

    @pyqtSlot()
    def start_get_customer_express_cost(self):
        ExpressService.start_get_customer_express_cost()

    @pyqtSlot()
    def start_get_customer_reject_express_cost(self):
        ExpressService.start_get_customer_reject_express_cost()

    @pyqtSlot()
    def start_store_customer_express(self):
        ExpressService.start_store_customer_express()

    @pyqtSlot()
    def start_store_customer_reject_express(self):
        ExpressService.start_store_customer_reject_express()

    @pyqtSlot(int)
    def start_customer_load_reject_express_list(self, page):
        ExpressService.start_customer_load_reject_express_list(page)

    @pyqtSlot()
    def start_load_customer_send_express_count(self):
        ExpressService.start_load_customer_send_express_count()

    @pyqtSlot()
    def start_load_customer_reject_express_count(self):
        ExpressService.start_load_customer_reject_express_count()

    @pyqtSlot(str)
    def start_courier_take_send_express(self, send_express_id_list):
        ExpressService.start_staff_take_send_express_list(send_express_id_list)

    @pyqtSlot()
    def start_courier_take_send_express_all(self):
        ExpressService.start_staff_take_all_send_express()

    @pyqtSlot(str)
    def start_courier_take_reject_express(self, send_express_id_list):
        ExpressService.start_staff_take_reject_express_list(send_express_id_list)

    @pyqtSlot()
    def start_courier_take_reject_express_all(self):
        ExpressService.start_staff_take_all_reject_express()

    @pyqtSlot(int)
    def start_load_mouth_list(self, page):
        BoxService.start_load_mouth_list(page)

    @pyqtSlot()
    def start_load_manager_mouth_count(self):
        BoxService.start_load_manager_mouth_count()

    @pyqtSlot(str, str)
    def start_manager_set_mouth(self, box_id, box_status):
        BoxService.start_manager_set_mouth(box_id, box_status)

    @pyqtSlot(str)
    def start_manager_open_mouth(self, mouth_id):
        BoxService.start_manager_open_mouth(mouth_id)

    @pyqtSlot()
    def start_manager_open_all_mouth(self):
        BoxService.start_manager_open_all_mouth()

    @pyqtSlot(str)
    def start_manager_set_free_mouth(self, box_id):
        BoxService.start_manager_set_free_mouth(box_id)

    @pyqtSlot()
    def courier_get_user(self):
        UserService.courier_get_user()

    @pyqtSlot(str)
    def start_customer_load_send_express_list(self, page):
        ExpressService.start_customer_load_send_express_list(page)

    @pyqtSlot(str, str)
    def start_choose_mouth_size(self, mouth_size, method_type):
        BoxService.start_choose_mouth_size(mouth_size, method_type)

    @pyqtSlot(str)
    def start_choose_mouth_enable(self, method_type):
        BoxService.start_choose_mouth_enable(method_type)

    @pyqtSlot(str)
    def start_get_imported_express(self, text):
        ExpressService.start_get_imported_express(text)

    @pyqtSlot()
    def start_explorer(self):
        logging.warning("SYSTEM CLOSED BY OPERATOR")
        AlertService.system_closed_alert()
        os.system("start explorer.exe")

    @pyqtSlot(str)
    def start_video_capture(self, filename):
        Camera.start_video_capture(filename)

    @pyqtSlot()
    def start_get_electronic_commerce_reject_express(self, ):
        ExpressService.start_get_electronic_commerce_reject_express()

    @pyqtSlot(str)
    def start_customer_reject_for_electronic_commerce(self, barcode):
        ExpressService.start_customer_reject_for_electronic_commerce(barcode)

    @pyqtSlot()
    def start_store_customer_reject_for_electronic_commerce(self):
        ExpressService.start_store_customer_reject_for_electronic_commerce()

    @pyqtSlot(str)
    def start_download_source(self, a):
        DownloadService.start_download_source(a)

    @pyqtSlot()
    def start_get_ad_file(self):
        AdvertisermentService.start_get_ad_file()


'''
    @pyqtSlot()
    def in_scan_code_page(self):
        ExpressService.in_scan_code_page()

    @pyqtSlot()
    def out_scan_code_page(self):
        ExpressService.out_scan_code_page()

    @pyqtSlot()
    def start_scan_qr_code(self):
        ExpressService.start_scan_qr_code()
'''


def signal_handler():
    ExpressService.express_signal_handler.customer_take_express_signal.connect(
        view.rootObject().customer_take_express_result)
    BoxService.box_signal_handler.mouth_number_signal.connect(view.rootObject().mouth_number_result)

    BoxService.box_signal_handler.manager_get_box_info_signal.connect(view.rootObject().manager_get_box_info_result)

    BoxService.box_signal_handler.get_version_signal.connect(view.rootObject().get_version_result)
    ExpressService.express_signal_handler.overdue_cost_signal.connect(view.rootObject().overdue_cost_result)

    UserService.user_signal_handler.user_login_signal.connect(view.rootObject().user_login_result)

    ExpressService.express_signal_handler.barcode_signal.connect(view.rootObject().barcode_result)
    ExpressService.express_signal_handler.store_express_signal.connect(view.rootObject().store_express_result)
    ExpressService.express_signal_handler.phone_number_signal.connect(view.rootObject().phone_number_result)

    ExpressService.express_signal_handler.paid_amount_signal.connect(view.rootObject().paid_amount_result)

    UserService.user_signal_handler.user_info_signal.connect(view.rootObject().user_info_result)

    ExpressService.express_signal_handler.customer_store_express_signal.connect(
        view.rootObject().customer_store_express_result)
    ExpressService.express_signal_handler.about_oainfo_express_signal.connect(
        view.rootObject().get_oainfo_result)
    ExpressService.express_signal_handler.about_oainfo_express_signal.connect(
        view.rootObject().get_oainfo_result_message)

    ExpressService.express_signal_handler.customer_take_express_disks_signal.connect(
        view.rootObject().customer_take_express_disks_result)
    ExpressService.express_signal_handler.customer_take_express_disks_message_signal.connect(
        view.rootObject().customer_take_express_disks_result_message)

    ExpressService.express_signal_handler.check_oa1_result_signal.connect(
        view.rootObject().check_oa1_result)

    BoxService.box_signal_handler.mouth_status_signal.connect(view.rootObject().mouth_status_result)

    BoxService.box_signal_handler.free_mouth_num_signal.connect(view.rootObject().free_mouth_result)

    ExpressService.express_signal_handler.overdue_express_list_signal.connect(
        view.rootObject().overdue_express_list_result)

    ExpressService.express_signal_handler.overdue_express_count_signal.connect(
        view.rootObject().overdue_express_count_result)

    BoxService.box_signal_handler.init_client_signal.connect(
        view.rootObject().init_client_result
    )

    ExpressService.express_signal_handler.staff_take_overdue_express_signal.connect(
        view.rootObject().courier_take_overdue_express_result)

    ExpressService.express_signal_handler.load_express_list_signal.connect(
        view.rootObject().load_express_list_result)

    ExpressService.express_signal_handler.customer_store_express_cost_signal.connect(
        view.rootObject().customer_store_express_cost_result)

    ExpressService.express_signal_handler.customer_express_cost_insert_coin_signal.connect(
        view.rootObject().customer_express_cost_insert_coin_result
    )

    ExpressService.express_signal_handler.store_customer_express_result_signal.connect(
        view.rootObject().store_customer_express_result_result
    )

    ExpressService.express_signal_handler.send_express_list_signal.connect(
        view.rootObject().send_express_list_result)

    ExpressService.express_signal_handler.send_express_count_signal.connect(
        view.rootObject().send_express_count_result)

    ExpressService.express_signal_handler.staff_take_send_express_signal.connect(
        view.rootObject().take_send_express_result)

    BoxService.box_signal_handler.manager_mouth_count_signal.connect(view.rootObject().manager_mouth_count_result)
    BoxService.box_signal_handler.load_mouth_list_signal.connect(view.rootObject().load_mouth_list_result)
    BoxService.box_signal_handler.mouth_list_signal.connect(view.rootObject().mouth_list_result)
    BoxService.box_signal_handler.manager_set_mouth_signal.connect(view.rootObject().manager_set_mouth_result)
    BoxService.box_signal_handler.manager_open_mouth_by_id_signal.connect(
        view.rootObject().manager_open_mouth_by_id_result)

    UserService.user_signal_handler.courier_get_user_signal.connect(view.rootObject().courier_get_user_result)

    BoxService.box_signal_handler.manager_open_all_mouth_signal.connect(view.rootObject().manager_open_all_mouth_result)

    BoxService.box_signal_handler.choose_mouth_signal.connect(view.rootObject().choose_mouth_result)

    BoxService.box_signal_handler.free_mouth_by_size_result.connect(view.rootObject().free_mouth_by_size_result)

    ExpressService.express_signal_handler.imported_express_result_signal.connect(
        view.rootObject().imported_express_result)

    ExpressService.express_signal_handler.customer_reject_express_signal.connect(
        view.rootObject().customer_reject_express_result)

    ExpressService.express_signal_handler.reject_express_signal.connect(view.rootObject().reject_express_result)
    ExpressService.express_signal_handler.reject_express_list_signal.connect(
        view.rootObject().reject_express_list_result)

    DownloadService.download_signal_handler.ad_download_result_signal.connect(view.rootObject().ad_download_result)
    DownloadService.download_signal_handler.delete_result_signal.connect(view.rootObject().delete_result)

    AdvertisermentService.ad_signal_handler.ad_source_signal.connect(view.rootObject().ad_source_result)
    AdvertisermentService.ad_signal_handler.ad_source_number_signal.connect(view.rootObject().ad_source_number_result)


def configuration_log():
    if not os.path.exists(sys.path[0] + "/log/"):
        os.makedirs(sys.path[0] + "/log/")
    handler = logging.handlers.TimedRotatingFileHandler(sys.path[0] + "/log/base.log", "MIDNIGHT", 1, backupCount=50, )
    logging.basicConfig(
        handlers=[handler],
        level=logging.DEBUG,
        format='%(asctime)s %(levelname)s %(funcName)s:%(lineno)d: %(message)s',
        datefmt='%d/%m %H:%M:%S'
    )


def get_disk_info():
    encrypt_str = ""
    c = wmi.WMI()
    disk_info = []
    for physical_disk in c.Win32_DiskDrive():
        encrypt_str = encrypt_str + physical_disk.SerialNumber.strip()
        disk_info.append(physical_disk.SerialNumber.strip())
    HttpClient.disk_serial_number = disk_info[0]


def check_database(data_name):
    if not os.path.exists(sys.path[0] + '/database/' + data_name + '.db'):
        ClientDatabase.init_database()


if __name__ == '__main__':

    #os.system("taskkill /f /im explorer.exe")
    path = sys.path[0] + '/qml/'
    if os.name == 'nt':
        path = 'qml/'
    slot_handler = SlotHandler()
    app = QGuiApplication(sys.argv)
    view = QQuickView()
    context = view.rootContext()
    translator = QTranslator()
    context.setContextProperty("slot_handler", slot_handler)
    translator.load(path + 'first.qm')
    app.installTranslator(translator)
    view.engine().quit.connect(app.quit)
    view.setSource(QUrl(path + 'Main.qml'))
    signal_handler()

    #app.setOverrideCursor(Qt.BlankCursor)
    #view.setFlags(Qt.WindowFullscreenButtonHint)
    #view.setFlags(Qt.FramelessWindowHint)
    #view.resize(1023, 768)

    configuration_log()
    get_disk_info()
    check_database("pakpobox")

    view.show()

    PushMessage.start_sync_message()
    PushMessage.start_time_task()
    PullMessage.start_pull_message()
    PushMessage.start_upgrade_task()
    BoxService.start_upgrade_init()

    pygame.init()
    Camera.init_camera()
    MusicService.init_music()

    BoxService.start_set_version()

    app.exec_()
