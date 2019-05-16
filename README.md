# ros2-docker-bleeding-edge
This repository contains a Dockerfile which is based on the [official build instructions](https://index.ros.org/doc/ros2/Installation/Crystal/Linux-Development-Setup/) for ROS2 Crystal Clemmys on Ubuntu Bionic Beaver (18.04).

## Build the container
```
git clone https://github.com/betab0t/ros2-docker-bleeding-edge
docker build . --tag ros2-docker-bleeding-edge
```

## Run the container
```
docker run -it ros2-docker-bleeding-edge
```

## Run the container with GUI
```
xhost +local:{$USER}
docker run -it \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    ros2-docker-bleeding-edge bash
```
_**for more information regrading gui config please visit [ROS wiki](http://wiki.ros.org/docker/Tutorials/GUI)._
