#!/usr/bin/env python
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D
import os

def read_nxny(nlfile):
    with open(nlfile) as f:
        for line in f:
            if "nx" in line:
                nx = int(line.strip().split()[-1])
            if "ny" in line:
                ny = int(line.strip().split()[-1])
    return nx, ny

cwd = os.getcwd()
src_dir = os.path.join(cwd, "out")
out_dir = os.path.join(cwd, "fig")
nlfile = "name.list"

nx, ny = read_nxny(nlfile)

for fname in os.listdir(src_dir):

    name = fname[5:-4]

    infile = os.path.join(src_dir, fname)

    with open(infile) as f:
        data = np.genfromtxt(f)

    temp = np.reshape(data[:, 2], (nx, ny))
    x = np.reshape(data[:, 0], (nx, ny)) 
    y = np.reshape(data[:, 1], (nx, ny))

    fig = plt.figure(figsize=(12,8))
    
    # 2D 
    #plt.imshow(temp, interpolation="none", vmin=0.0, vmax = 1.0)

    # 2D CONTOUR PLOT
    #levels = np.linspace(0.0,20.0,21)
    #plt.contourf(x, y, temp, levels, cmap=cm.coolwarm, )
    
    # 3D WIRE PLOT
    ax = fig.add_subplot(1, 1, 1, projection='3d')
    surf = ax.plot_wireframe(x, y, temp, color = "r")
    ax.set_zlim3d(0.0, 20.0)

    #3D SURFACE PLOT
    #ax = fig.add_subplot(1, 1, 1, projection='3d')
    #surf = ax.plot_surface(x, y, temp, rstride=1, cstride=1, cmap="viridis",
            #cm.coolwarm,
            #                       linewidth=0, antialiased=False)
    #ax.set_zlim3d(0.0, 20)

    outfile = os.path.join(out_dir, name + ".jpg")
    plt.savefig(outfile)
    plt.clf()
    plt.close()
