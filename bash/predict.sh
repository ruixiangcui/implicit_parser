#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-1
#SBATCH --array=1-3

# UCCA
for split in dev test; do
  allennlp predict \
  --cuda-device -1 \
  --output-file ucca-output$SLURM_ARRAY_TASK_ID.$split.mrp \
  --predictor transition_predictor_ucca \
  --include-package utils \
  --include-package modules \
  --include-package metrics \
  --use-dataset-reader \
  --batch-size 32 \
  --silent \
  checkpoints/ucca_bert1${PREFIX:-}$SLURM_ARRAY_TASK_ID \
  data/ewt.$split.aug.companion.mrp

  mkdir -p data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split
  python toolkit/mtool/main.py data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.mrp data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.xml --read mrp --write ucca
  csplit -zk data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.xml '/^<root/' -f '' -b "data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split/%03d.xml" {553}
  python -m semstr.evaluate data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.dev data/ewt/dev -qs ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.dev.scores.txt
done
