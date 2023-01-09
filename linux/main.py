import cv2
import sys

cap = cv2.VideoCapture(0)

if not cap.isOpened():
    print("not opened")
    sys.exit()
    
while True:
    ret, frame = cap.read()

    if not ret:
        print("not ret")
        break

    edge = cv2.Canny(frame, 50, 150)

    cv2.imshow('frame', frame)
    cv2.imshow('edge', edge)

    if cv2.waitKey(10) == 27:
        break

cap.release()
cv2.destroyAllWindows()
