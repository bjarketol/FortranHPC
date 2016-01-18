#!/usr/bin/env python
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D
import os

cwd = os.getcwd()
src_dir = os.path.join(cwd, "out")
out_dir = os.path.join(cwd, "fig")


for fname in os.listdir(src_dir):

    name = fname[:-4]

    infile = os.path.join(src_dir, fname)

    with open(infile) as f:
        data = np.genfromtxt(f)

    temp = np.reshape(data[:, 2], (41, 41))
    x = np.reshape(data[:, 0], (41, 41)) 
    y = np.reshape(data[:, 1], (41, 41))


    fig = plt.figure(figsize=(12,8))
    
    # 2D 
    #plt.imshow(temp, interpolation="none", vmin=0.0, vmax = 1.0)

    # 2D CONTOUR PLOT
    #plt.contourf(x, y, temp)
    
    # 3D WIRE PLOT
    #ax = fig.add_subplot(1, 1, 1, projection='3d')
    #surf = ax.plot_wireframe(x, y, temp, color = "r")
    #ax.set_zlim3d(0.0, 1)

    #3D SURFACE PLOT
    ax = fig.add_subplot(1, 1, 1, projection='3d')
    surf = ax.plot_surface(x, y, temp, rstride=1, cstride=1, cmap=cm.coolwarm,
                                   linewidth=0, antialiased=False)
    ax.set_zlim3d(0.0, 1)


    outfile = os.path.join(out_dir, name + ".png")
    plt.savefig(outfile)
    plt.clf()
    plt.close()
