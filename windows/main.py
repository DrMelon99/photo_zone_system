import glob, os
import cv2

image_path = 'D:/github/photo_zone_system/windows/images/'
image_name = 'test_image'
image_extension = '.jpg'

image = cv2.imread(image_path + image_name + image_extension)

cv2.namedWindow('image', cv2.WINDOW_NORMAL)
cv2.setWindowProperty('image', cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
cv2.imshow('image', image)

cv2.waitKey(0)
cv2.destroyWindow()