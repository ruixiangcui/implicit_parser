#!/bin/bash

# Download from http://svn.nlpl.eu/mrp/2019/public/companion.tgz and extract
cat data/ewt0*.conllu > data/ewt.conllu
python toolkit/augment_data.py data/ewt.conllu ../mrp/2019/training/ucca/ewt.mrp data/ewt.aug.mrp
for split in train dev test; do
  grep -Ff file-lists/$split.txt data/ewt.aug.mrp > data/ewt.$split.aug.mrp
done

# Get gold data to evaluate on
git clone https://github.com/UniversalConceptualCognitiveAnnotation/UCCA_English-EWT -b v1.0-sentences data/ewt
mkdir data/ewt/{train,dev,test}
for split in train dev test; do
  xargs -I % find data/ewt -maxdepth 1 -name '%*.pickle' < file-lists/$split.txt | xargs ln -srt data/ewt/$split
done
