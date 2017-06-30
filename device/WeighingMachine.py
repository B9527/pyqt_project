from PyQt5.QtCore import QObject, pyqtSignal
import time
import serial
import ClientTools

__author__ = 'gaoyang'

weighing_machine = None


class WeighingMachineSignalHandler(QObject):
    weight_signal = pyqtSignal(int)


weighing_machine_signal_handler = WeighingMachineSignalHandler()


def init_weighing_machine():
    global weighing_machine
    weighing_machine = serial.Serial(**ClientTools.get_port_value("WeighingMachine", 9600, 'COM3', 30))


def get_weighing_machine():
    global weighing_machine
    if weighing_machine is None:
        init_weighing_machine()
    return weighing_machine


start_flag = False


def clean_weight():
    get_weighing_machine().write((0xff, 0xaa, 0xfa, 0xf5))


def start_get_weight():
    global start_flag
    # clean_weight()
    # time.sleep(2)
    start_flag = True
    ClientTools.get_global_pool().apply_async(get_weight)


weigh_value = 0


def get_weight():
    global start_flag, weigh_value
    weigh_list = []
    while start_flag:
        result_ = get_weighing_machine().read(4)
        weigh_value = weight_data_to_value(result_)
        if len(weigh_list) >= 20:
            weigh_list.pop(0)
        else:
            weigh_list.append(weigh_value)
        if len(weigh_list) == 20:
            sum1 = 0.0
            sum2 = 0.0
            for i in range(0, len(weigh_list)):
                sum1 += weigh_list[i]
                sum2 += weigh_list[i] ** 2
            mean = sum1 / len(weigh_list)
            var = sum2 / len(weigh_list) - mean ** 2
            if var < 2:
                weigh_value = mean
                break
        time.sleep(1)
    weighing_machine_signal_handler.weight_signal.emit(weigh_value)


def weight_data_to_value(receive_data):
    weight_result_data = receive_data[2] * 0x100 + receive_data[3]
    return weight_result_data
