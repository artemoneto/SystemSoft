#!/bin/bash

gnome-terminal --window --command roscore
sleep 2

gnome-terminal --tab --command "rosrun turtlesim turtlesim_node"
sleep 2
rosservice call kill turtle1

#2
rosservice call spawn 2.2 2.5 0 turtle2
rostopic pub -1 /turtle2/cmd_vel geometry_msgs/Twist -- '[-2.0, 0.0, 0.0]' '[0.0, 0.0, 0.0]'
rosservice call turtle2/teleport_relative 3 1
rostopic pub -1 /turtle2/cmd_vel geometry_msgs/Twist -- '[3.0, 0.0, 0.0]' '[0.0, 0.0, 3.5]'
rosservice call kill turtle2

#4
rosservice call spawn 3.2 2.5 1.57 turtle4
rostopic pub -1 /turtle4/cmd_vel geometry_msgs/Twist -- '[3.8, 0.0, 0.0]' '[0.0, 0.0, 0.0]'
rostopic pub -1 /turtle4/cmd_vel geometry_msgs/Twist -- '[-2.3, 0.0, 0.0]' '[0.0, 0.0, 0.0]'
rosservice call turtle4/teleport_relative 1.5 1.57
rosservice call turtle4/teleport_relative 2.7 4.3
rosservice call kill turtle4

#3
rosservice call spawn 3.5 2.5 0 turtle3
rosservice call turtle3/teleport_relative 0.3 0
rostopic pub -1 /turtle3/cmd_vel geometry_msgs/Twist -- '[3.14, 0.0, 0.0]' '[0.0, 0.0, 3.14]'
rosservice call turtle3/teleport_relative 0.2 0
rosservice call turtle3/teleport_relative 0.2 3.14
rostopic pub -1 /turtle3/cmd_vel geometry_msgs/Twist -- '[3.14, 0.0, 0.0]' '[0.0, 0.0, 3.14]'
rosservice call kill turtle3

#9
rosservice call spawn 5.0 3.4 4.712 turtle9
rostopic pub -1 /turtle9/cmd_vel geometry_msgs/Twist -- '[3.14, 0.0, 0.0]' '[0.0, 0.0, 3.1]'
rosservice call turtle9/teleport_relative 2.2 0
rostopic pub -1 /turtle9/cmd_vel geometry_msgs/Twist -- '[6.28, 0.0, 0.0]' '[0.0, 0.0, 6.28]'
rosservice call kill turtle9

#5
rosservice call spawn 7.5 2.5 0 turtle5
rostopic pub -1 /turtle5/cmd_vel geometry_msgs/Twist -- '[4.0, 0.0, 0.0]' '[0.0, 0.0, 3.14]'
rosservice call turtle5/teleport_relative 1.5 4.71
rosservice call turtle5/teleport_relative 1.5 4.71
rosservice call kill turtle5

#0
rosservice call spawn 8.9 3.4 4.712 turtle0
rostopic pub -1 /turtle0/cmd_vel geometry_msgs/Twist -- '[3.14, 0.0, 0.0]' '[0.0, 0.0, 3.14]'
rosservice call turtle0/teleport_relative 2.2 0
rostopic pub -1 /turtle0/cmd_vel geometry_msgs/Twist -- '[3.14, 0.0, 0.0]' '[0.0, 0.0, 3.14]'
rosservice call turtle0/teleport_relative 2.2 0
rosservice call kill turtle0
