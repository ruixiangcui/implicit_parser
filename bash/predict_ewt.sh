#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-10

# UCCA
for split in dev test; do
  allennlp predict \
  --cuda-device -1 \
  --output-file data/ewt/ucca-output-$split.mrp \
  --predictor transition_predictor_ucca \
  --include-package utils \
  --include-package modules \
  --include-package metrics \
  --use-dataset-reader \
  --batch-size 32 \
  --silent \
  checkpoints/ucca_bert_ewt \
  data/ewt/ewt.$split.aug.mrp

  mkdir -p data/ewt/ucca-ewt-output.$split
  python toolkit/mtool/main.py data/ewt/ucca-ewt-output-$split.mrp data/ewt/ucca-ewt-output-$split.xml --read mrp --write ucca
  csplit -zk data/ewt/ucca-ewt-output.$split.xml '/^<root/' -f '' -b "data/ewt/ucca-ewt-output.$split/%03d.xml" {553}
  python -m semstr.evaluate data/ewt/ucca-ewt-output.dev data/ewt/dev -qs ucca-ewt-output.dev.scores.txt
done

  python toolkit/mtool/main.py data/ewt/ucca-output-dev.mrp data/ewt/ucca-output-dev.xml --read mrp --write ucca

  csplit -zk data/ewt/ucca-output-dev.xml '/^<root/' -f '' -b "data/ewt/ucca-output-dev/%03d.xml" {555}
  perl -nle 'print $& while m{(?<=passageID=")[^"]*(?=")}g' data/ewt/ucca-output-dev/* > data/ewt/dev-name.txt
  for file in data/ewt/ucca-output-dev/*.xml; do read line; mv -v "${file}" "data/ewt/ucca-output-dev/${line}.xml"; done < data/ewt/dev-name.txt
  python -m semstr.evaluate data/ewt/ucca-output-dev data/ewt/dev -qs data/ewt/ucca-output.dev.scores.txt
