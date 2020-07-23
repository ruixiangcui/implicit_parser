#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-10
#SBATCH --array=1-3

# UCCA
for split in dev test; do
  allennlp predict \
  --cuda-device -1 \
  --output-file data/ucca-output.mrp \
  --predictor transition_predictor_ucca \
  --include-package utils \
  --include-package modules \
  --include-package metrics \
  --use-dataset-reader \
  --batch-size 32 \
  --silent \
  checkpoints/ucca_bert \
  data/ewt.$split.aug.companion.mrp

  mkdir -p data/ucca-output.$split
  python toolkit/mtool/main.py data/ucca-output.$split.mrp data/ucca-output.$split.xml --read mrp --write ucca
  csplit -zk data/ucca-output.$split.xml '/^<root/' -f '' -b "data/ucca-output.$split/%03d.xml" {553}
  python -m semstr.evaluate data/ucca-output.dev data/ewt/dev -qs ucca-output.dev.scores.txt
done

  python toolkit/mtool/main.py data/ucca-output1.test.mrp data/ucca-output1.test.xml --read mrp --write ucca
  csplit -zk data/ucca-output1.test.xml '/^<root/' -f '' -b "data/ucca-output1.test/%03d.xml" {533}

  perl -nle 'print $& while m{(?<=passageID=")[^"]*(?=")}g' data/ucca-output1.test/* > data/testname.txt
  for file in *.xml; do read line; mv -v "${file}" "${line}.xml"; done < ../testname.txt

  python -m semstr.evaluate data/ucca-output1.test data/ewt/test -qs ucca-output1.test.scores.txt

  python toolkit/mtool/main.py data/ucca-output1.test.mrp data/ucca-output1.test.xml --read mrp --write ucca
