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
          img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
          cv2.imwrite(os.path.join(output, i), cv2.resize(img, (40,40)))
          num = num + 1


    
if __name__ == "__main__":
    main(sys.argv[1])