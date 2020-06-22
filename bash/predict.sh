#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-10
#SBATCH --array=1-3

# UCCA
for split in dev test; do
  allennlp predict \
  --cuda-device -1 \
  --output-file data/ucca-output$SLURM_ARRAY_TASK_ID.$split.mrp \
  --predictor transition_predictor_ucca \
  --include-package utils \
  --include-package modules \
  --include-package metrics \
  --use-dataset-reader \
  --batch-size 32 \
  --silent \
  checkpoints/ucca_bert${PREFIX:-}$SLURM_ARRAY_TASK_ID \
  data/ewt.$split.aug.companion.mrp

  mkdir -p data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split
  python toolkit/mtool/main.py data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.mrp data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.xml --read mrp --write ucca
  csplit -zk data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.xml '/^<root/' -f '' -b "data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split/%03d.xml" {553}
  python -m semstr.evaluate data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.dev data/ewt/dev -qs ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.dev.scores.txt
done

  python toolkit/mtool/main.py data/ucca-output1.test.mrp data/ucca-output1.test.xml --read mrp --write ucca
  csplit -zk data/ucca-output1.dev.xml '/^<root/' -f '' -b "data/ucca-output1.dev/%03d.xml" {534}

  perl -nle 'print $& while m{(?<=passageID=")[^"]*(?=")}g' data/ucca-output1.dev/* > data/devname.txt
  for file in *.xml; do read line; mv -v "${file}" "${line}.xml"; done < ../devname.txt

  python -m semstr.evaluate data/ucca-output1.dev data/ewt/dev -qs ucca-output1.dev.scores.txt

  python toolkit/mtool/main.py data/ucca-output1.dev.mrp data/ucca-output1.dev.xml --read mrp --write ucca
