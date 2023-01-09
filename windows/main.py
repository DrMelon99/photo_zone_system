import cv2

# image path & name & extension
image_path = 'D:/github/photo_zone_system/windows/images/'
image_name = 'test_image'
image_extension = '.jpg'
image = cv2.imread(image_path + image_name + image_extension)

# fullscreen output
cv2.namedWindow('image', cv2.WINDOW_NORMAL)
cv2.setWindowProperty('image', cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)

# loading
loading_gif = cv2.VideoCapture(image_path + 'loading' + '.gif')
while cv2.waitKey(33) < 0:
    if loading_gif.get(cv2.CAP_PROP_POS_FRAMES) == loading_gif.get(cv2.CAP_PROP_FRAME_COUNT):
        loading_gif.set(cv2.CAP_PROP_POS_FRAMES, 0)
    
    ret, frame = loading_gif.read()
    cv2.imshow('image', frame)
loading_gif.release()

# realtime image output
cv2.imshow('image', image)
cv2.waitKey(0)

cv2.destroyWindow('image')