#!/usr/bin/env python
import numpy as np
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

with open("output.dat") as f:
    data = np.genfromtxt(f)

temp = np.reshape(data[:, 2], (50, 50))
x = np.reshape(data[:, 0], (50, 50)) 
y = np.reshape(data[:, 1], (50, 50))


fig = plt.figure(figsize=(12,8))
ax = fig.add_subplot(1, 1, 1, projection='3d')

surf = ax.plot_wireframe(x, y, temp, color="r")

ax.set_zlim3d(-0.07, 0.01)

plt.show()

