# A Machine Learning alternative to PID controllers
## CS229 Final Project - Fall 2017

### Application
Quadcopter control using Reinforcement Learning (RL) or Deep Learning (DL) - replacing tradi- tional PID controllers

### Motivation
Current quadcopter stabilization is performed using classical PID controllers.
These controllers usually perform well, but can lead to poor performance when non-linearities are introduced, which is the case for quadcopters in a clustered environment.
Our project intends to implement an RL or DL controller for quadcopter stabilization.
To effectively compare our proposed algorithm with a classical PID controller, we intend on testing the stabilization of an inverted pendulum that would be mounted on the drone.
The angle θ between the inverted pendulum rod and a vector normal to the ground will be a measurement of how stable the drone is.

