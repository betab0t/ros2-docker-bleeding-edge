FROM ubuntu:bionic

ENV CHOOSE_ROS_DISTRO=crystal
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y \
    curl \
    gnupg2 \
    lsb-release \
    locales \
    locales-all

# Set a locale that supports UTF-8
RUN locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

# Add ROS2 apt repositories
RUN curl http://repo.ros2.org/repos.key | apt-key add - && \
    sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'

# Install development tools and ROS tools
RUN apt update && \
    apt install -y \
    build-essential \
    cmake \
    git \
    python3-colcon-common-extensions \
    python3-lark-parser \
    python3-pip \
    python-rosdep \
    python3-vcstool \
    wget

RUN python3 -m pip install -U \
    argcomplete \
    flake8 \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest-repeat \
    pytest-rerunfailures \
    pytest \
    pytest-cov \
    pytest-runner \
    setuptools

# Install Fast-RTPS dependencies
RUN apt install --no-install-recommends -y \
    libasio-dev \
    libtinyxml2-dev

# Get ROS 2 code
RUN mkdir -p ~/ros2_ws/src && \
    cd ~/ros2_ws && \
    wget https://raw.githubusercontent.com/ros2/ros2/master/ros2.repos && \
    vcs import src < ros2.repos

# Install dependencies using rosdep
RUN rosdep init && \
    rosdep update && \
    cd ~/ros2_ws && \
    rosdep install --from-paths src --ignore-src --rosdistro crystal -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 rti-connext-dds-5.3.1 urdfdom_headers" && \
    python3 -m pip install -U lark-parser

# Build the code in the workspace
RUN cd ~/ros2_ws && \
    colcon build --symlink-install

CMD source ~/ros2_ws/install/setup.bash && \
    bash
