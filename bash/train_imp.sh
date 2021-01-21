#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=7-0
#SBATCH -p gpu --gres=gpu:titanrtx:1
#SBATCH -c10
#SBATCH --array=1-3%1
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=rc@di.ku.dk


exp=$1
CHECKPOINTS=checkpoints/imp_$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID

TRAIN_PATH=data/imp/imp.train.aug.mrp \
DEV_PATH=data/imp/imp.dev.aug.mrp \
BERT_PATH=bert/wwm_cased_L-24_H-1024_A-16 \
WORD_DIM=1024 \
LOWER_CASE=FALSE \
SEED=$SLURM_ARRAY_TASK_ID \
BATCH_SIZE=4 \
allennlp train \
-s $CHECKPOINTS \
--include-package utils \
--include-package modules \
--include-package metrics \
--file-friendly-logging \
config/transition_bert_ucca.jsonnet