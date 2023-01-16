from deepface import DeepFace
import cv2
import json

image_path = "linux/deepface/image.jpg"
webcam = cv2.VideoCapture(0)

if not webcam.isOpened():
    print("Could not open webcam")
    exit()
        
while webcam.isOpened():
    status, frame = webcam.read()
    
    if status:
        cv2.imwrite(image_path, frame)
        demography = DeepFace.analyze(image_path)
        print(demography)
        x, y, w, h = demography['region'].values()
        print(x, y, w, h)

        if x != 0 and y != 0:
            cv2.rectangle(frame, [x, y], [x + w, y + h], (0, 0, 255), 3)
        cv2.imshow("test", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

webcam.release()
cv2.destroyAllWindows()
