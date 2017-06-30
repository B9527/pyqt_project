import os
import pygame
import pygame.camera
import time
import sys
import logging
import ClientTools

cam = None
logger = logging.getLogger()
file_path = sys.path[0] + "/video_capture/"


def init_camera():
    global cam, file_path
    if not os.path.exists(file_path):
        os.makedirs(file_path)
    pygame.camera.init()
    pygame.camera.list_cameras()
    try:
        cam = pygame.camera.Camera(0, (640, 480))
    except Exception as e:
        cam = None
        logger.error(("init_camera ERROR :", e))


def start_video_capture(filename):
    ClientTools.get_global_pool().apply_async(video_capture, (filename,))


def video_capture(filename):
    global cam, file_path
    try:
        if cam is None:
            return
        delete_capture_file()
        cam.start()
        img = cam.get_image()
        cam_time = time.strftime('%Y%m%d%H%M%S', time.localtime(time.time()))
        cam_name = file_path + cam_time + '_' + filename + '.jpg'
        pygame.image.save(img, cam_name)
        cam.stop()

    except Exception as e:
        logger.warn(("video_capture ERROR", e))


def delete_capture_file():
    global file_path
    tady_time = ClientTools.today_time()
    capture_file = os.listdir(file_path)
    for _capture_file in capture_file:
        file_date = _capture_file.split("_")[0]
        _capture_date = file_date[0:4] + "-" + file_date[4:6] + "-" + file_date[6:8]
        _capture_time = int(time.mktime(time.strptime(_capture_date, "%Y-%m-%d")))

        if tady_time - _capture_time >= 5184000:
            # remove
            os.remove(os.path.join(file_path, _capture_file))
