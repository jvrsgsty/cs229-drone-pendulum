from os import path
import sys
sys.path.append(path.abspath('../gym'))

import gym
env = gym.make('FlyingPendulum-v0')
# env.reset()
# for _ in range(1000):
#     env.render()
#     env.step(env.action_space.sample()) # take a random action

env = gym.make('FlyingPendulum-v0')
for i_episode in range(1):
    observation = env.reset()
    f=open("states%s.txt" %i_episode, "a+")
    f.write('\n'+','.join([str(a) for a in observation]))
    f.close()
    for t in range(10000):
        env.render()
        # print(observation)
        action = env.action_space.sample()
        f=open("actions%s.txt" %i_episode, "a+")
        f.write('\n'+','.join([str(a) for a in action]))
        f.close()
        observation, reward, done, info = env.step(action)
        f=open("states%s.txt" %i_episode, "a+")
        f.write('\n'+','.join([str(a) for a in observation]))
        f.close()
        if done:
            print("Episode finished after {} timesteps".format(t+1))
            break
