#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-10
#SBATCH --array=1-3

# UCCA
for split in dev test; do
  allennlp predict \
  --cuda-device -1 \
  --output-file data/imp/ucca-imp-output-$split.mrp \
  --predictor transition_predictor_ucca \
  --include-package utils \
  --include-package modules \
  --include-package metrics \
  --use-dataset-reader \
  --batch-size 32 \
  checkpoints/ucca_bert \
  data/imp/imp.$split.aug.mrp

  mkdir -p data/imp/ucca-imp-output-$split
  for i in 1 2; do
    python toolkit/mtool/main.py data/imp/ucca-imp-output-$split.mrp data/imp/ucca-imp-output-$split.xml --read mrp --write ucca
  done
  csplit -zk data/imp/ucca-imp-output-$split.xml '/^<root/' -f '' -b "data/imp/ucca-imp-output-$split/%03d.xml" {533}
  perl -nle 'print $& while m{(?<=passageID=")[^"]*(?=")}g' data/imp/ucca-imp-output-$split/* > data/imp/$split-name.txt
  cd data/imp/ucca-imp-output-$split
  for file in *.xml; do read line; mv -v "${file}" "${line}.xml"; done < ../$split-name.txt
  cd -
  python -m semstr.evaluate data/imp/ucca-imp-output-$split data/imp/$split -qs data/imp/ucca-imp-output.$split.scores.txt
done

