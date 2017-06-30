import json
import logging
import os
import time
import ClientTools

import Configurator
from box.service import BoxService
from device import LockMachine
from device import MaSungPrinter
from device import CoinMachine
from device import Scanner
from express.service import ExpressService
from sync import PullMessage
from user.service import UserService

__author__ = 'gaoyang'
import unittest2


class ConfiguratorTest(unittest2.TestCase):
    def setUp(self):
        Configurator.set_value("CoinMachine", "port", "com5")

    def tearDown(self):
        os.remove("config.conf")

    def testGetValue(self):
        self.assertEqual(Configurator.get_value("CoinMachine", "port"), "com5")
        self.assertEqual(Configurator.get_value("CoinMachine", "None"), None)
        self.assertEqual(Configurator.get_value("None", "None"), None)

    def testSetValue(self):
        Configurator.set_value("None Section", "None Option", "None Value")
        self.assertEqual(Configurator.get_value("None Section", "None Option"), "None Value")


class LockMachineTest(unittest2.TestCase):
    def testCheckData(self):
        self.assertEqual(LockMachine.check_data([0xA0, 0x08, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x5A, ]), True)
        self.assertEqual(LockMachine.check_data([0xA0, 0x08, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x5B, ]), False)

    def testConvertData(self):
        result = LockMachine.convert_lock_status([0xA0, 0x08, 0xFF, 0xCE, 0xFF, 0x00, 0x00, 0x00, 0x5A, ])
        self.assertEqual(
            [False, False, False, False, False, False, False, False, True, False, False, False, True, True, False,
             False, False, False, False, False, False, False, False, False], result)


class MaSungPrinterTest(unittest2.TestCase):
    def testPrinter(self):
        MaSungPrinter.express_info_template(sender_name='高阳', sender_phone='18566691050', receiver_name='Dawn',
                                            receiver_phone='18566691051', receiver_address='广东省深圳市南山区\n高新科技园中区一路腾讯大厦',
                                            wight='1.2kg', barcode='12345678')

    def testPrintBarcode(self):
        MaSungPrinter.print_barcode('12345678')

    def testGeneratePrintBarcodeCommand(self):
        self.assertEqual(MaSungPrinter.generate_barcode_command('12345678'),
                         (0x1d, 0x6b, 0x45, 0x08, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38))


class ScannerTest(unittest2.TestCase):
    def testScanner(self):
        print(Scanner.start_get_text_info())


class CoinMachineTest(unittest2.TestCase):
    def testCheckData(self):
        self.assertTrue(CoinMachine.check_data(b'\x90\x05P\x03\xe8'))
        self.assertTrue(CoinMachine.check_data(b'\x90\x06\x12\x03\x03\xae'))
        self.assertFalse(CoinMachine.check_data(b'\x90\x06\x12\x03\x03\xaf'))

    def testGetCoin(self):
        print(CoinMachine.get_coin())


class BoxServiceTest(unittest2.TestCase):
    def testInitClient(self):
        UserService.login("12345678", "888888")
        BoxService.init_client()


class UserServiceTest(unittest2.TestCase):
    def testLoginSuccess(self):
        UserService.login("GAOYANG", "PASSWORD")


class ExpressServiceTest(unittest2.TestCase):
    def testLoadOverdueExpress(self):
        UserService.login("GY911201", "PASSWORD")
        ExpressService.courier_load_overdue_express(0)

    def testLoadOverdueExpressCount(self):
        UserService.login("GY911201", "PASSWORD")
        ExpressService.load_courier_overdue_express_count()

    def testLoadCustomerExpress(self):
        ExpressService.customer_store_number = "P201501"
        ExpressService.get_customer_store_express_info()

    def testStartCalculateCustomerExpressCost(self):
        ExpressService.start_calculate_customer_express_cost()
        time.sleep(5)

    def testStoreCustomerExpress(self):
        ExpressService.customer_store_express = json.loads(
            '{"id":"f37fa91cf7a211e4b7926c40088b8482","customerStoreNumber":"P201501",'
            '"expressType":"CUSTOMER_STORE","logisticsCompany":{"id":"05d36c76d6aa11e4b91d6c40088b8482",'
            '"name":"测试物流公司","companyType":"LOGISTICS_COMPANY"},'
            '"storeUser":{"id":"ace76ad2f7a211e49b736c40088b8482"},"recipientName":"高阳",'
            '"recipientUserPhoneNumber":"18566691650","takeUserPhoneNumber":"18566691650",'
            '"startAddress":{"id":"48eb7c50f7a311e49ec16c40088b8482","region":{"id":"35865af8f66411e4bd404ef6eab0b474",'
            '"name":"南山区","parentRegion":{"id":"e4e99678f66311e4bd404ef6eab0b474","name":"鹤岗",'
            '"parentRegion":{"id":"b3b57ab8f66311e4bd404ef6eab0b474","name":"黑龙江",'
            '"parentRegion":{"id":"a0bd0d9af66311e4bd404ef6eab0b474","name":"中国"}}}},"detailedAddress":"高新产业园"},'
            '"endAddress":{"id":"2494f228f7a311e4bb216c40088b8482","region":{"id":"358b9c7af66411e4bd404ef6eab0b474",'
            '"name":"宝安区","parentRegion":{"id":"e4ea8862f66311e4bd404ef6eab0b474","name":"深圳",'
            '"parentRegion":{"id":"b3b582cef66311e4bd404ef6eab0b474","name":"广东",'
            '"parentRegion":{"id":"a0bd0d9af66311e4bd404ef6eab0b474","name":"中国"}}}},"detailedAddress":"任达科技园"},'
            '"rangePrice":{"id":"a4ded9a6f7a011e48bfb6c40088b8482",'
            '"businessType":{"id":"ca6ef91cf7a011e490516c40088b8482","name":"今日送"},'
            '"startRegion":{"id":"35865af8f66411e4bd404ef6eab0b474","name":"南山区",'
            '"parentRegion":{"id":"e4e99678f66311e4bd404ef6eab0b474","name":"鹤岗",'
            '"parentRegion":{"id":"b3b57ab8f66311e4bd404ef6eab0b474","name":"黑龙江",'
            '"parentRegion":{"id":"a0bd0d9af66311e4bd404ef6eab0b474","name":"中国"}}}},'
            '"endRegion":{"id":"358b9c7af66411e4bd404ef6eab0b474","name":"宝安区",'
            '"parentRegion":{"id":"e4ea8862f66311e4bd404ef6eab0b474","name":"深圳",'
            '"parentRegion":{"id":"b3b582cef66311e4bd404ef6eab0b474","name":"广东",'
            '"parentRegion":{"id":"a0bd0d9af66311e4bd404ef6eab0b474","name":"中国"}}}},'
            '"firstHeavy":5000,"firstPrice":1000,"continuedHeavy":1000,"continuedPrice":200},"version":0,'
            '"status":"IMPORTED"}')
        ExpressService.customer_express_weight = 1000
        ExpressService.mouth_size = "S"
        ExpressService.store_customer_express()


class PullMessageTest(unittest2.TestCase):
    def testPullMessage(self):
        PullMessage.pull_message()


class ClientToolsTest(unittest2.TestCase):
    def testUUID(self):
        print(ClientTools.get_uuid())
