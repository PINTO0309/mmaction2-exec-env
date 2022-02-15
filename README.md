# mmaction2-exec-env


## 1. Usage
### 1-1. Docker Pull
```bash
$ docker pull pinto0309/mmaction2_exec_env:latest
```
### 1-2. Docker Build
```bash
$ docker build -t mmaction2_exec_env .
```

### 1-3. Docker Run
```bash
$ docker run --gpus all --rm -it \
--shm-size=10g \
-v `pwd`:/mmaction2/data \
-v /tmp/.X11-unix/:/tmp/.X11-unix:rw \
--device /dev/video0:/dev/video0:mwr \
--net=host \
-e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
-e DISPLAY=$DISPLAY \
--privileged \
--name mmaction2_exec_env \
mmaction2_exec_env
```

## 2. Test
```bash
$ python3 demo/demo_skeleton.py demo/ntu_sample.avi demo/skeleton_demo.mp4 \
--config configs/skeleton/posec3d/slowonly_r50_u48_240e_ntu120_xsub_keypoint.py \
--checkpoint https://download.openmmlab.com/mmaction/skeleton/posec3d/slowonly_r50_u48_240e_ntu120_xsub_keypoint/slowonly_r50_u48_240e_ntu120_xsub_keypoint-6736b03f.pth \
--det-config demo/faster_rcnn_r50_fpn_2x_coco.py \
--det-checkpoint http://download.openmmlab.com/mmdetection/v2.0/faster_rcnn/faster_rcnn_r50_fpn_2x_coco/faster_rcnn_r50_fpn_2x_coco_bbox_mAP-0.384_20200504_210434-a5d8aa15.pth \
--det-score-thr 0.9 \
--pose-config demo/hrnet_w32_coco_256x192.py \
--pose-checkpoint https://download.openmmlab.com/mmpose/top_down/hrnet/hrnet_w32_coco_256x192-c78dce93_20200708.pth \
--label-map tools/data/skeleton/label_map_ntu120.txt
```
