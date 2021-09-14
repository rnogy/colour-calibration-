import os
import cv2
import numpy
import sys

def main(output):
    num = 1
    for i in os.listdir(output):
        img = cv2.imread(os.path.join(output, i))
        print(type(img))
        print(os.path.join(os.getcwd(), i))
        if type(img) == numpy.ndarray:
          print(i)
          cv2.imwrite(img, cv2.resize(img, (80,80)))
          num = num + 1


    
if __name__ == "__main__":
    main(sys.argv[1])