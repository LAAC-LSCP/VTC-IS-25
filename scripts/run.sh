audios_path=audios
output=out/$(date +%Y%m%d_%H%M)_inference_output

mkdir -p $output
uv run scripts/save_load_whisper.py --model small

uv run scripts/infer.py \
    --config model/config.yml \
    --wavs $audios_path \
    --checkpoint model/best.ckpt\
    --output $output

uv run scripts/merge_segments.py \
    --folder $output/rttm \
    --output $output/merged_rttm
