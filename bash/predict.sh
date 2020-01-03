#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-1
#SBATCH -p gpu --gres=gpu:titanx:1

# examples of predicting commands

# UCCA
CUDA_VISIBLE_DEVICES=0 \
allennlp predict \
--cuda-device 0 \
--output-file ucca-output.dev.mrp \
--predictor transition_predictor_ucca \
--include-package utils \
--include-package modules \
--use-dataset-reader \
--batch-size 32 \
--silent \
checkpoints/ucca_bert \
data/ewt.dev.aug.mrp

CUDA_VISIBLE_DEVICES=0 \
allennlp predict \
--cuda-device 0 \
--output-file ucca-output.test.mrp \
--predictor transition_predictor_ucca \
--include-package utils \
--include-package modules \
--use-dataset-reader \
--batch-size 32 \
--silent \
checkpoints/ucca_bert \
data/ewt.test.aug.mrp
