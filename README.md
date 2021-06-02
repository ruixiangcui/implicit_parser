# Implicit UCCA Parser

This repository accompanies the paper, "Great Service! Fine-grained Parsing of Implicit Arguments", providing codes to train models and pre/post-precessing mrp dataset.

master branch contains Implicit-eager parser, alternative branch contains Implicit-standard parser

## Pre-requisites

- Python 3.6
- NLTK
- Gensim
- Penman
- AllenNLP 0.9.0

## Dataset

Total training data is available at [mrp-data].

## Model
For prediction, please specify the BERT path in `config.json` to import the bert-indexer and bert-embedder. More prediction commands could be found in `bash/predict.sh`.

About BERT version, we use wwm_cased_L-24_H-1024_A-16.

## Usage

### Prepare data

We use conllu format companion data. This command adds `companion.conllu` to `data.mrp` and outputs to `data.aug.mrp`

```shell script
bash bash/get_imp.sh

### Train the parser

Based on AllenNLP, the training command is like

```shell script
CUDA_VISIBLE_DEVICES=${gpu_id} \
TRAIN_PATH=${train_set} \
DEV_PATH=${dev_set} \
BERT_PATH=${bert_path} \
WORD_DIM=${bert_output_dim} \
LOWER_CASE=${whether_bert_is_uncased} \
BATCH_SIZE=${batch_size} \
    allennlp train \
        -s ${model_save_path} \
        --include-package utils \
        --include-package modules \
        --file-friendly-logging \
        ${config_file}
```

Refer to `bash/train_imp.sh` for more and detailed examples.

### Predict with the parser

The predicting command is like

```shell script
CUDA_VISIBLE_DEVICES=${gpu_id} \
    allennlp predict \
        --cuda-device 0 \
        --output-file ${output_path} \
        --predictor ${predictor_class} \
        --include-package utils \
        --include-package modules \
        --batch-size ${batch_size} \
        --silent \
        ${model_save_path} \
        ${test_set}
```
Refer to `bash/predict_imp.sh` for more and detailed examples.

## Package structure

* `bash/` command pipelines and examples
* `config/` Jsonnet config files
* `metrics/` metrics used in training and evaluation
* `modules/` implementations of modules
* `toolkit/` external libraries and dataset tools
* `utils/` code for input/output and pre/post-processing


## Contacts

For further information, please contact <rc@di.ku.dk>
