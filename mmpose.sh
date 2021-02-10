#!/bin/bash

# launch multiple jobs
# for dirname in /cvgl/u/jkamalu/H3DR/jrdb_coco/train_dataset/image/toy-00010/*; do sbatch ./mmpose.sh --data $dirname; done

#SBATCH --partition=napoli-gpu
#SBATCH --nodes=1
#SBATCH --mem=64G
#SBATCH -c 8
#SBATCH --time 60
#SBATCH --job-name="mmpose-infer"
#SBATCH --gres=gpu:titanx:2

OPTIND=1

GPUS=2

while [ "$1" != "" ]; do
    case $1 in
        --data )
            shift
            PATH_TO_DATA=$1
        ;;
        * )
            exit
    esac
    shift
done

if [ -z $PATH_TO_DATA ]; then
    echo "--data is required"
    exit
fi

MMPOSE=/cvgl/u/jkamalu/mmpose

PATH_TO_CKPT="${MMPOSE}/models/pytorch/top_down/hrnet/hrnet_w48_coco_384x288_dark-741844ba_20200812.pth"
PATH_TO_RSLT="${PATH_TO_DATA}/$(basename $PATH_TO_CKPT .pth).json"

COMMAND="python -m torch.distributed.launch --nproc_per_node=${GPUS} ${MMPOSE}/tools/jrdb.py $PATH_TO_DATA $PATH_TO_CKPT --out $PATH_TO_RSLT --launcher pytorch"
echo $COMMAND

echo "Current time : $(date +"%T")"

srun --nodes=${SLURM_NNODES} bash -c "source /cvgl/u/jkamalu/miniconda3/bin/activate && conda activate open-mmlab && ${COMMAND}"

echo "Current time : $(date +"%T")"

exit
