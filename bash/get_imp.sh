#Get UCCA IMP data XML
git clone https://github.com/ruixiangcui/UCCA_English-IMP -b v0.9 data/imp

# Download parsed companion data from http://svn.nlpl.eu/mrp/2019/public/companion.tgz and extract
wget -qO- http://svn.nlpl.eu/mrp/2019/public/companion.tgz?p=28375 | tar xvz
cat mrp/2019/companion/ucca/ewt0*.conllu > data/ewt.companion.conllu

# Augment data
python toolkit/augment_data.py data/ewt.companion.conllu data/imp/imp.mrp data/imp/imp.aug.companion.mrp

# Split augmented data to train/dev/test
for split in train dev test; do
  grep -Ff file-lists/$split.txt data/imp/imp.aug.companion.mrp > data/imp/imp.$split.aug.companion.mrp
  done

#split byte files to train/dev/test
mkdir -p data/imp/{train,dev,test}
for split in train dev test; do
  xargs -I % find data/imp/pickle -maxdepth 1 -name '%*.pickle' < file-lists/$split.txt | xargs -I "{}" cp "{}" data/imp/$split
done