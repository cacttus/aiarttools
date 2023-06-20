#!/bin/bash

#run stable diffusion webui for all gpus separate ports

function quit_err() {
  echo -e "Error: $1"
  echo -e "\n"
  read -p 'Press any key to exit.'
}

type nvidia-smi &>/dev/null
if [[ ! $? ]]; then
  quit_err "nvidia-smi / driver not installed (only Nvidia GPUs for now)"
else
  gnome-terminal --window --geometry=50x5+100+10 -- bash -c "~/git/gpustatus.sh/gpustatus.sh"
  gpucount=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader | wc -l)
  winyoff=156
  winysiz=266
  baseport=7860
  for ((i=0;i<$gpucount;i++)) ; do
    gnome-terminal --window --geometry=130x12+100+${winyoff} -- bash -c "export CUDA_VISIBLE_DEVICES=0; cd ~/git/stable-diffusion-webui; ./webui.sh --port $(( ${baseport} + ${i} ))"
    winyoff=$(( ${winyoff} + ${winysiz} ))
  done
fi

#manual run
#./venv/bin/python3 ./webui.py

