mkdir Positive_img
mkdir Negative_img
#mkdir Validation_set
#mkdir ./Validation_set/Negative_img
#mkdir ./Validation_set/Positive_img

echo "Downloading Positive Images"
mkdir pos_images
curl -SL "https://github.com/rnogy/pos_images/archive/refs/heads/main.zip" > ./pos_images/file.zip
unzip ./pos_images/file.zip -d ./pos_images
mv ./pos_images/pos_images-main/*.jpg ./Positive_img
rm -rf ./pos_images

echo "Downlaoding the Negative Images"
mkdir temp
curl -SL https://github.com/JoakimSoderberg/haarcascade-negatives/archive/refs/heads/master.zip > ./temp/file.zip
unzip ./temp/file.zip -d ./temp

i=0
find ./temp -iname "*.jpg" > temp.txt
while IFS= read -r line; do mv "$line" ./Negative_img/"$i".jpg ; i=$((i+1)); done < temp.txt
rm -rf temp.txt
rm -rf temp

python Resize.py "$(PWD | awk '{print $0"/Positive_img"}')"
python Resize.py "$(PWD | awk '{print $0"/Negative_img"}')"
#mv $(find ./Negative_img -type f | sort -zR | tail -n +300) ./Validation_set/Negative_img
echo "Finished Downloading Images"


echo "Creating Samples"
find ./Positive_img -iname "*.jpg" | awk '{print $0" 1 0 0 80 80"}' > positives.txt
find ./Negative_img -iname "*.jpg" | awk '{print $0" 1 0 0 80 80"}' > negatives.txt

opencv_createsamples -info positives.txt  -w 80 -h 80 -vec samples.vec
echo "end of gathering samples"


echo "Start Training"
mkdir classifier

#Assuming the device has more than 6 GB of Ram

opencv_traincascade -data classifier -vec samples.vec -bg negatives.txt\
          -numStages 20 -minHitRate 0.999 -maxFalseAlarmRate 0.5 -numPos 1000\
          -numNeg 2000 -w 80 -h 80 -mode ALL -precalcValBufSize 3072\
          -precalcIdxBufSize 3072
echo "End Of Training"
