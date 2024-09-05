FROM dorowu/ubuntu-desktop-lxde-vnc:latest

# 작업 디렉토리 설정
WORKDIR /root
ENV HOME=/root SHELL=/bin/bash
###################### Image Layers ################################

# ROS Installation
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN apt update && apt install lsb -y --fix-missing
RUN apt install lsb -y
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt install curl -y
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN sudo apt update --fix-missing -y
RUN sudo apt-get install -f
RUN sudo apt install ros-noetic-desktop-full -y
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN sudo -s source ~/.bashrc
RUN sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential python3-roslaunch ca-certificates -y
RUN rosdep init && rosdep update

# Catkin_ws setting
RUN apt update && apt install python3-catkin-tools gedit python3-osrf-pycommon nano -y
RUN mkdir -p ~/catkin_ws/src
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; catkin_init_workspace ~/catkin_ws/src'
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /root/catkin_ws; catkin build'
WORKDIR /root/catkin_ws
RUN sudo wstool init src

# Turtlebot3 Dependency Packages Installation
RUN sudo apt install ros-noetic-joy ros-noetic-teleop-twist-joy -y
RUN sudo apt install ros-noetic-teleop-twist-keyboard -y
RUN sudo apt install ros-noetic-laser-proc -y
RUN sudo apt install ros-noetic-rgbd-launch -y
RUN sudo apt install ros-noetic-rosserial-arduino -y
RUN sudo apt install ros-noetic-rosserial-python -y
RUN sudo apt install ros-noetic-rosserial-client -y
RUN sudo apt install ros-noetic-rosserial-msgs -y
RUN sudo apt install ros-noetic-amcl -y
RUN sudo apt install ros-noetic-map-server -y
RUN sudo apt install ros-noetic-move-base -y
RUN sudo apt install ros-noetic-urdf -y
RUN sudo apt install ros-noetic-xacro -y
RUN sudo apt install ros-noetic-compressed-image-transport -y
RUN sudo apt install ros-noetic-gmapping -y
RUN sudo apt install ros-noetic-navigation -y
RUN sudo apt install ros-noetic-interactive-markers -y
RUN sudo apt install ros-noetic-dynamixel-sdk -y
RUN sudo apt install ros-noetic-turtlebot3-msgs -y
RUN sudo apt install ros-noetic-turtlebot3 -y

# Turtlebot3 setting
WORKDIR /root/catkin_ws/src
RUN git clone -b noetic-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
WORKDIR /root/catkin_ws/src
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /root/catkin_ws; catkin build'
RUN echo "export TURTLEBOT3_MODEL=burger" >> ~/.bashrc
RUN sudo -s source ~/.bashrc

###################################################################