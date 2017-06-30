import logging
import pygame
import time
from PyQt5.QtCore import QObject, pyqtSignal
import sys
import ClientTools

__author__ = 'admin'


class MusicSignalHandler(QObject):
    music_signal = pyqtSignal(str)


logger = logging.getLogger()
mixer_music = pygame.mixer.music


def init_music():
    pygame.mixer.init()

express_signal_handler = MusicSignalHandler()

start_flag = False


def track_start(filename1, filename2):
    global start_flag, mixer_music
    if not start_flag:
        start_flag = True
        mixer_music.load("music/source/" + filename1 + ".mp3")
        mixer_music.play(1)
        while mixer_music.get_busy():
            pygame.time.delay(100)
    if start_flag and filename2 is not None:
        mixer_music.load("music/source/" + filename2 + ".mp3")
        mixer_music.play(1)
        while mixer_music.get_busy():
            pygame.time.delay(100)


def track_stop():
    global mixer_music
    mixer_music.stop()


def start_play_music(filename1, filename2):
    ClientTools.get_global_pool().apply_async(track_start, (filename1, filename2,))


def stop_play_music():
    global start_flag
    if start_flag:
        start_flag = False
        track_stop()
