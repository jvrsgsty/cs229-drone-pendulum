# Inverted Pendulum on a Quadcopter: A Reinforcement Learning Approach
## CS229 Final Project - Fall 2017

### Motivation
Current quadcopter stabilization is done using classical PID controllers. They usually perform well expect for:
* altitude control, due to complex airflow interactions present in the system.
* when non-linearities are introduced, which is the case in clustered environments.
We envision reinforcement learning as a major breakthrough in the field of robotic control as it eliminates the need for a predefined controller structure which limits the overall performance and costs more human effort.
In other words, reinforcement learning avoids creating manually-tuned control algorithms to complete specific tasks.
This technique could lead to building tailored, adaptable, autonomously learned controllers for drones and other types of robotic technologies.

### Code structure
The source code can be found inside the code folder.
The final version of the code we used can be found under code/FVI/

The other durectories contain the following:
* The FVI folder contains an implementation where the control vector matches what would be used in a real life drone.
* The FVI/acc folder contains a version of the simulator in which we only control the spatial acceletarion of the drone (not really controlling thrust, roll pitch and yaw)
* The Matlab Simulator folder contains the initial implementation of the quadcopter dynamics
* The OpenAI folder contains some test we ran when attempting to use OpenAI gym.
* The gym folder was forked from the OpenAI repository (https://github.com/openai/gym) when we attempted to create a virtual environment for our problem.
* The value_it folver contains our initial implementation of the Fitted Value Iteration algorithm using different feature mappings and reward functions.
