#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=5-0
#SBATCH -p gpu --gres=gpu:titanx:1
#SBATCH -c10

exp=$1
CHECKPOINTS=checkpoints/imp_$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID

TRAIN_PATH=data/imp/imp.train.aug.mrp \
DEV_PATH=data/imp/imp.dev.aug.mrp \
BERT_PATH=bert/wwm_cased_L-24_H-1024_A-16 \
WORD_DIM=1024 \
LOWER_CASE=FALSE \
SEED=$RANDOM \
BATCH_SIZE=4 \
allennlp train \
-s $CHECKPOINTS \
--include-package utils \
--include-package modules \
--include-package metrics \
--file-friendly-logging \
config/transition_bert_ucca.jsonnet