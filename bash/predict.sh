#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-1
#SBATCH -p gpu --gres=gpu:titanx:1
#SBATCH --array=1-3

# UCCA
CUDA_VISIBLE_DEVICES=0 \
allennlp predict \
--cuda-device 0 \
--output-file ucca-output$SLURM_ARRAY_TASK_ID.dev.mrp \
--predictor transition_predictor_ucca \
--include-package utils \
--include-package modules \
--use-dataset-reader \
--batch-size 32 \
--silent \
checkpoints/ucca_bert$SLURM_ARRAY_TASK_ID \
data/ewt.dev.aug.mrp

CUDA_VISIBLE_DEVICES=0 \
allennlp predict \
--cuda-device 0 \
--output-file ucca-output$SLURM_ARRAY_TASK_ID.test.mrp \
--predictor transition_predictor_ucca \
--include-package utils \
--include-package modules \
--use-dataset-reader \
--batch-size 32 \
--silent \
checkpoints/ucca_bert$SLURM_ARRAY_TASK_ID \
data/ewt.test.aug.mrp
