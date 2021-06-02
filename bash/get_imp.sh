#!/bin/bash

mkdir -p data

#Get UCCA IMP data XML and MRP
git clone https://github.com/ruixiangcui/UCCA-Refined-Implicit-EWT_English.git data
mv UCCA-Refined-Implicit-EWT_English imp

# Split augmented data to train/dev/test
for split in train dev test; do
  grep -Ff file-lists/$split.txt data/imp/imp.aug.mrp > data/imp/imp.$split.aug.mrp
  done

#split byte files to train/dev/test
mkdir -p data/imp/{train,dev,test}
for split in train dev test; do
  xargs -I % find data/imp/all -maxdepth 1 -name '%*.xml' < file-lists/$split.txt | xargs -I "{}" cp "{}" data/imp/$split
done

# Get mtool
git clone https://github.com/ruixiangcui/mtool  toolkit/mtool