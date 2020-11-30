export SCENE_DIR=$1
export SCENE=$2

MMPOSE=/cvgl/u/jkamalu/mmpose

read -r -d '' COMMAND <<- EOM
  python
    $MMPOSE/demo/top_down_img_demo.py
    $MMPOSE/configs/jrdb/hrnet_w32_coco_384x288_dark.py
    $MMPOSE/models/pytorch/top_down/hrnet/hrnet_w32_coco_384x288_dark-459422a4_20200812.pth
    --img-root jrdb_coco/$SCENE_DIR/$SCENE/images
    --json-file jrdb_coco/$SCENE_DIR/$SCENE/annotations.json
    --out-img-root $MMPOSE/output/jrdb/$SCENE_DIR/hrnet_w32_coco_384x288_dark/images/$SCENE/
EOM

eval $COMMAND