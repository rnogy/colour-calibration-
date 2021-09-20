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

python Resize.py $(pwd | awk '{print $0"/Positive_img"}')
python Resize.py $(pwd | awk '{print $0"/Negative_img"}')
#mv $(find ./Negative_img -type f | sort -zR | tail -n +300) ./Validation_set/Negative_img
echo "Finished Downloading Images"

echo "Creating Samples"
find $(pwd)/Positive_img -iname "*.jpg" | awk '{print $0" 1 0 0 24 24"}' > positives.info
find $(pwd)/Negative_img -iname "*.jpg"  > negatives.info

opencv_createsamples -info positives.info -vec samples.vec -w 24 -h 24 -num 2000
echo "end of gathering samples"

echo "Start Training"
mkdir classifier

#Assuming the device has more than 6 GB of Ram

opencv_traincascade -data classifier -vec $(pwd)/samples.vec -bg negatives.info\
          -numStages 10 -numPos 500\
          -numNeg 500 -w 24 -h 24 -mode ALL -precalcValBufSize 2048\
          -precalcIdxBufSize 2048

echo "End Of Training"
