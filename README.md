 # Haar_Cascade_Classifier_Training

Note: This project is a modification of my high school APCSA final project. Some links or APIs might not be functional anymore due to the passage of time. 
Regretfully, I do not have the package version number nor the Docker container. However, it was a project I'm VERY proud of. 

## Background

This program will uses images taken to train a haar cascade classifer. 
The trained model can then be used to detect the object. With the intention for calibrate the image colour later on.

## Requirements
Python 3.3+ or Python 2.7

Linux or macOS
OpenCV


Python Libraries:

 * cv2
 * numpy


## Usage


```bash
sh OneClick.sh
```

## Docker

```bash
docker build .
```

Unfortunately, it is not possible to mount host dir during build. 
Please use "--mount type=bind,source=<host dir>,target=/test" when starting the docker. You can run sh OneClick.sh insider the container.

## Sidenote

This program assumes you have at least 6 GB of Ram.

Edit the following parameter to change the Ram accordingly.

For example, increase the number of Ram for faster processing.

```bash
opencv_traincascade -data classifier -vec samples.vec -bg negatives.txt\
          -numStages 20 -minHitRate 0.999 -maxFalseAlarmRate 0.5 -numPos 1000\
          -numNeg 2000 -w 80 -h 80 -mode ALL -precalcValBufSize < MB of ram >\
          -precalcIdxBufSize < MB of ram >
```

Note that the combination of both parameters equals the amount of Ram you wish to use.

The training is assuming to be done on a computer, the model can be implemented in edge devices. 
 
## PS
 
Nagative images are taken from https://github.com/JoakimSoderberg/haarcascade-negatives. 
