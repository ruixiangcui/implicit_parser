#!/bin/bash
#SBATCH --job-name=hitparser
#SBATCH --mem=30G
#SBATCH --time=0-6
#SBATCH -p gpu --gres=gpu:titanx:1
#SBATCH --array=1-1%1

# UCCA
CUDA_VISIBLE_DEVICES=0 \
TRAIN_PATH=data/ewt.train.aug.streusle.mrp \
DEV_PATH=data/ewt.dev.aug.streusle.mrp \
BERT_PATH=bert/cased_L-12_H-768_A-12 \
WORD_DIM=768 \
LOWER_CASE=FALSE \
BATCH_SIZE=8 \
allennlp train \
-s checkpoints/ucca_bert${PREFIX:-}$SLURM_ARRAY_TASK_ID \
--include-package utils \
--include-package modules \
--include-package metrics \
--file-friendly-logging \
config/transition_bert_ucca.jsonnet "$@"

