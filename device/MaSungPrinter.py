import Configurator
import ClientTools
import serial
__author__ = 'gaoyang'


printer = None
character_set = 'gbk'


def init_printer():
    global character_set, printer
    if Configurator.get_value("Printer", "character_set"):
        character_set = Configurator.get_value("Printer", "character_set")
    printer = serial.Serial(**ClientTools.get_port_value("Printer", 38400, 'COM3'))


def get_printer():
    if printer is None:
        init_printer()
    return printer


def print_text_left(text):
    get_printer().write(bytes(text, encoding=character_set))
    get_printer().write((0x0A,))


def print_text_left_and_right(left_text, right_text):
    get_printer().write(bytes(left_text, encoding=character_set))
    get_printer().write((0x09,))
    get_printer().write(bytes(right_text, encoding=character_set))
    get_printer().write((0x0A,))


def print_barcode(barcode):
    get_printer().write((0x1D, 0x50, 1))
    get_printer().write((0x1D, 0x68, 96))
    get_printer().write(generate_barcode_command(barcode))


def generate_barcode_command(barcode):
    barcode = str(barcode)
    result = [0x1D, 0x6B, 69, len(barcode)]
    for c in barcode:
        result.append(ord(c))
    return tuple(result)


def paper_feed():
    get_printer().write((0x1D, 0x0C))


def paper_cult():
    get_printer().write((0x1B, 0x69))


def express_info_template(sender_name, sender_phone, receiver_name, receiver_phone, receiver_address, wight,
                          barcode):
    print_text_left_and_right('寄件人姓名：' + sender_name, '寄件人电话：' + sender_phone)
    print_text_left_and_right('收件人姓名：' + receiver_name, '收件人电话：' + receiver_phone)
    print_text_left('收件人地址：' + receiver_address)
    print_text_left('快件重量：' + wight)
    print_barcode(barcode)
    paper_feed()
    paper_cult()
