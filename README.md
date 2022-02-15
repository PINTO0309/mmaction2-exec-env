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
