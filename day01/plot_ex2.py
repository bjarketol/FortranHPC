#!/usr/bin/env python
import numpy as np
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

with open("temp.txt") as f:
    data = np.genfromtxt(f)

temp = np.reshape(data[:, 2], (21, 21))
x = np.reshape(data[:, 0], (21, 21)) 
y = np.reshape(data[:, 1], (21, 21))


fig = plt.figure(figsize=(12,8))
ax = fig.add_subplot(1, 1, 1, projection='3d')

surf = ax.plot_wireframe(x, y, temp, color="r")

ax.set_zlim3d(0.8, 1)

plt.show()

