# Challenges in Automated Processing of Speech from Child Wearables: The Case of Voice Type Classifier

> **Abstract**
>
> Recordings gathered with child-worn devices promised to revolutionize both fundamental and applied speech sciences by allowing the effortless capture of children's naturalistic speech environment and language production. This promise hinges on speech technologies that can transform the sheer mounds of data thus collected into usable information. This paper demonstrates several obstacles blocking progress by summarizing three years' worth of experiments aimed at improving one fundamental task: Voice Type Classification. Our experiments suggest that improvements in representation features, architecture, and parameter search contribute to only marginal gains in performance. More progress is made by focusing on data relevance and quantity, which highlights the importance of collecting data with appropriate permissions to allow sharing.

## Description
This repo contains the script needed to **train** the Whisper-VTC models, perform **inference** on a set of audio files and **evaluate** the models given ground-truth annotations.

## How to use
Ensure that you have [uv](https://github.com/astral-sh/uv) installed on you system.

Clone the repo and setup dependencies:
```python
git clone git@github.com:LAAC-LSCP/VTC-IS-25.git
cd VTC-IS-25

uv sync
```

### Preparing the data
The audio files for inference simply needs to lie in a simple repository, the inference script will load them automatically.

For training, the data is loaded in a specific way using [segma](https://github.com/arxaqapi/segma) and its [SegmaFileDataset](https://github.com/arxaqapi/segma/blob/49c1ce4bace130785c7be0e5aab6a8ed3bd0d711/src/segma/data/file_dataset.py#L41-L64) class.
In short the data needs to have the following structure:

```txt
dataset_name/
    ├── rttm/
    │   └── 0000.rttm
    │   └── 0001.rttm
    ├── uem/ (optional)
    │   └── 0000.uem
    │   └── 0001.uem
    ├── wav/
    │   └── 0000.wav
    │   └── 0001.wav
    ├── train.txt
    ├── val.txt
    ├── test.txt
    └── exclude.txt (optional)
```

Where `train.txt`, `val.txt` and `test.txt` are list of unique identifiers that link the audios (.wav) to their annotation (.rttm).

The structure of a RTTM or a UEM file is best described in [pyannote-database](https://github.com/pyannote/pyannote-database/blob/develop/README.md#segmentation).

### Getting the pre-trained Whisper small encoder
Before anything can be trained or infered, you'll need to download the weights of the pre-trained Whisper small model using the `save_load_whisper.py` scripts.

```python
uv run scripts/save_load_whisper.py --model small
```

### Training
The `config.yml` contains most of the variables needed for training. Refer to `segma` for more informations on training a model.

```sh
uv run scripts/train.py \
    --config config/config.yml \

```

### Inference
Inference is done using a checkpoint of the model, linking to the corresponding config file used for the trianing and the list of audio files to run thee inference on.

```sh
uv run scripts/infer.py \
    --config model/config.yml \
    --wavs audios \
    --checkpoint model/best.ckpt \
    --output predictions
```


### Segment merging (optional)
Simply specify the input folder and output folder.
For more fine-grained tuning, use the `min-duration-on-s` and `min-duration-off-s` parameters.

```sh
uv run scripts/merge_segments.py \
    --folder rttm_folder \
    --output rttm_merged
```


### Helper script
To perform inference and speech segment merging (see merge_segments.py for help or [this pyannote.audio description](https://github.com/pyannote/pyannote-audio/blob/240a7f3ef60bc613169df860b536b10e338dbf3c/pyannote/audio/pipelines/resegmentation.py#L79-L82)), a single bash script is given.

Simply set the correct variables in the script and run it:
```sh
sh scripts/run.sh
```

## Citation

```bibtex
@inproceedings{kunze25_interspeech,
  title     = {{Challenges in Automated Processing of Speech from Child Wearables:  The Case of Voice Type Classifier}},
  author    = {Tarek Kunze and Marianne Métais and Hadrien Titeux and Lucas Elbert and Joseph Coffey and Emmanuel Dupoux and Alejandrina Cristia and Marvin Lavechin},
  year      = {2025},
  booktitle = {{Interspeech 2025}},
  pages     = {2845--2849},
  doi       = {10.21437/Interspeech.2025-1962},
  issn      = {2958-1796},
}
```

## Acknowledgement
This work uses the [segma](https://github.com/arxaqapi/segma) library which is heavely inspired by [pyannote.audio](https://github.com/pyannote/pyannote-audio).

The first version of the [Voice Type Classifier is available here](https://github.com/MarvinLvn/voice-type-classifier).
