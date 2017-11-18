import gym
from gym import spaces
from gym.utils import seeding
import numpy as np
from os import path
import pdb

class FlyingPendulumEnv(gym.Env):
    metadata = {
        'render.modes' : ['human', 'rgb_array'],
        'video.frames_per_second' : 30
    }

    def __init__(self):
        self.max_position = 15
        self.max_speed=5
        self.dt=.05
        self.length = 0.6
        self.gravity = 9.81

        high = np.array([self.max_position, self.max_position, self.max_position, \
                        self.max_speed, self.max_speed, self.max_speed, \
                        np.pi, np.pi, np.pi, \
                        self.length, self.length,
                        self.max_speed, self.max_speed])

        self.action_space = spaces.Box(-1, 1, shape=(4,))
        self.observation_space = spaces.Box(low=-high, high=high)

        self._seed()

    def _seed(self, seed=None):
        self.np_random, seed = seeding.np_random(seed)
        return [seed]

    def _step(self,action):
        assert self.action_space.contains(action), "%r (%s) invalid"%(action, type(action))
        state = self.state
        x, y,z, x_dot, y_dot, z_dot, alpha, beta, gamma, r, s, r_dot, s_dot = state
        a =  action[0]
        wx = action[1]
        wy = action[2]
        wz = action[3]

        ksi = np.sqrt(self.length**2- r**2 - s**2);

        # Rotation matrices
        Rx= np.matrix([[1, 0, 0], [0, np.cos(gamma), -np.sin(gamma)], [0, np.sin(gamma), np.cos(gamma)]])
        Ry = np.matrix([[np.cos(beta), 0, np.sin(beta)],[0, 1, 0], [-np.sin(beta), 0, np.cos(beta)]])
        Rz = np.matrix([[np.cos(alpha), -np.sin(alpha), 0], [np.sin(alpha), np.cos(alpha), 0], [0, 0, 1]])
        Ro = Rz*Ry*Rx;

        R_eulerToOmega = np.matrix([[np.cos(beta)*np.cos(gamma), -np.sin(gamma), 0],
                          [np.cos(beta)*np.sin(gamma), np.cos(gamma), 0],
                          [-np.sin(beta), 0, 1]]);
                      
        acceleration = Ro*np.array([[0], [0], [a]]) + np.array([[0], [0], [-self.gravity]])
        angular_rates = np.linalg.inv(R_eulerToOmega)*np.array([[wx], [wy], [wz]])

        A = (1/((self.length**2-s**2)*ksi**2))*( r**3*s + r*(-self.length**2*s + s**3) )
        B = (1/((self.length**2-s**2)*ksi**2))*( -r**4*acceleration[0] - (self.length**2-s**2)**2*acceleration[0] - 2*r**2*( s*s_dot*r_dot + \
        (-self.length**2+s**2)*acceleration[1]) + r**3*( s_dot**2 - ksi*(self.gravity+acceleration[2]) ) + r*( s**2*(r_dot**2-ksi*(self.gravity+acceleration[2])) + \
        self.length**2*(-r_dot**2-s_dot**2+ksi*(self.gravity+acceleration[2]))));

        C = (1/((self.length**2-r**2)*ksi**2))*( s**3*r + s*(-self.length**2*r + r**3) )
        D = (1/((self.length**2-r**2)*ksi**2))*(  -s**4*acceleration[1] - (self.length**2-r**2)**2*acceleration[1] - 2*s**2*( r*s_dot*r_dot + \
        (-self.length**2+r**2)*acceleration[2] ) + s**3*( r_dot**2 - ksi*(self.gravity+acceleration[2]) ) + s*( r**2*(s_dot**2-ksi*(self.gravity+acceleration[2])) + \
        self.length**2*(-r_dot**2-s_dot**2+ksi*(self.gravity+acceleration[2])) ) );

        x = x + self.dt*x_dot;
        y = y+self.dt*y_dot;
        z = z+self.dt*z_dot;

        x_dot = float(x_dot + self.dt*acceleration[0])
        y_dot = float(y_dot + self.dt*acceleration[1])
        z_dot = float(z_dot + self.dt*acceleration[2])

        alpha = float(alpha + self.dt*angular_rates[2])
        beta = float(beta + self.dt*angular_rates[1])
        gamma = float(gamma + self.dt*angular_rates[0])

        r = r + self.dt*r_dot;
        s = s + self.dt*s_dot;

        r_dot = r_dot + self.dt*(A*D+B)/(1-A*C);
        s_dot = s_dot + self.dt*(C*B+D)/(1-A*C);

        self.state = (x, y,z, x_dot, y_dot, z_dot, alpha, beta, gamma, r, s, r_dot, s_dot)

        
        done =  np.sqrt(r**2+s**2) > self.length - 0.1 
        done = bool(done)

        if not done:
            reward = 1.0-np.sqrt(r**2+s**2)
        elif self.steps_beyond_done is None:
            # Pole just fell!
            self.steps_beyond_done = 0
            reward = 1.0
        else:
            if self.steps_beyond_done == 0:
                logger.warning("You are calling 'step()' even though this environment has already returned done = True. You should always call 'reset()' once you receive 'done = True' -- any further steps are undefined behavior.")
            self.steps_beyond_done += 1
            reward = 0.0

        return np.array(self.state), reward, done, {}

    def _reset(self):
        self.state = self.np_random.uniform(low=-0.05, high=0.05, size=(13,))
        self.steps_beyond_done = None
        return np.array(self.state)


    # def _render(self, mode='human', close=False):
    #     if close:
    #         if self.viewer is not None:
    #             self.viewer.close()
    #             self.viewer = None
    #         return

    #     if self.viewer is None:
    #         from gym.envs.classic_control import rendering
    #         self.viewer = rendering.Viewer(500,500)
    #         self.viewer.set_bounds(-2.2,2.2,-2.2,2.2)
    #         rod = rendering.make_capsule(1, .2)
    #         rod.set_color(.8, .3, .3)
    #         self.pole_transform = rendering.Transform()
    #         rod.add_attr(self.pole_transform)
    #         self.viewer.add_geom(rod)
    #         axle = rendering.make_circle(.05)
    #         axle.set_color(0,0,0)
    #         self.viewer.add_geom(axle)
    #         fname = path.join(path.dirname(__file__), "assets/clockwise.png")
    #         self.img = rendering.Image(fname, 1., 1.)
    #         self.imgtrans = rendering.Transform()
    #         self.img.add_attr(self.imgtrans)

    #     self.viewer.add_onetime(self.img)
    #     self.pole_transform.set_rotation(self.state[0] + np.pi/2)
    #     if self.last_u:
    #         self.imgtrans.scale = (-self.last_u/2, np.abs(self.last_u)/2)

    #     return self.viewer.render(return_rgb_array = mode=='rgb_array')

def angle_normalize(x):
    return (((x+np.pi) % (2*np.pi)) - np.pi)