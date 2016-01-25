#!/usr/bin/env python
import numpy as np
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
import os
import sys
from collections import defaultdict

with open("name.list") as f:
    for line in f:
        if "nx" in line:
            nx = int(line.strip().split()[2])
        if "ny" in line:
            ny = int(line.strip().split()[2])
        if "ndimi" in line:
            ndimi = int(line.strip().split()[2])
        if "ndimj" in line:
            ndimj = int(line.strip().split()[2])
    
d = {}
for i, ifile in enumerate(sorted(os.listdir("out/"))): 
    print ifile
    with open(os.path.join("out",ifile)) as f:
        data = np.genfromtxt(f) 

    temp = np.reshape(data[:, 2], (nx/ndimi, ny/ndimj))
    x = np.reshape(data[:, 0], (nx/ndimi, ny/ndimj)) 
    y = np.reshape(data[:, 1], (nx/ndimi, ny/ndimj))
     
    d[str(i)] = {}
    d[str(i)]["temp"] = temp
    d[str(i)]["x"] = x
    d[str(i)]["y"] = y

hstack_t = dict()
hstack_x = dict()
hstack_y = dict()

for j in range(ndimj):
    for i in range(ndimi):
        rank = j*ndimi+i
        print rank
        if str(j) not in hstack_t.keys():
            hstack_t[str(j)] = d[str(rank)]["temp"]
        else:
            hstack_t[str(j)] = np.vstack([hstack_t[str(j)],d[str(rank)]["temp"]])
        if str(j) not in hstack_x.keys():
            hstack_x[str(j)] = d[str(rank)]["x"]
        else:
            hstack_x[str(j)] = np.vstack([hstack_x[str(j)],d[str(rank)]["x"]])
        if str(j) not in hstack_y.keys():
            hstack_y[str(j)] = d[str(rank)]["y"]
        else:
            hstack_y[str(j)] = np.vstack([hstack_y[str(j)],d[str(rank)]["y"]])

stack_t = "first"
stack_x = "first"
stack_y = "first"
for j in range(ndimj):
    if stack_t == "first":
        stack_t = hstack_t[str(j)]
    else:
        stack_t = np.hstack([stack_t,hstack_t[str(j)]])
    if stack_x == "first":
        stack_x = hstack_x[str(j)]
    else:
        stack_x = np.hstack([stack_x,hstack_x[str(j)]])
    if stack_y == "first":
        stack_y = hstack_y[str(j)]
    else:
        stack_y = np.hstack([stack_y,hstack_y[str(j)]])

fig = plt.figure(figsize=(12,8))
ax = fig.add_subplot(1, 1, 1, projection='3d')

surf = ax.plot_surface(stack_x, stack_y, stack_t,
                       rstride = 1,
                       cstride = 1,
                       cmap=cm.coolwarm,
                       linewidth=0,
                       antialiased=False)

plt.show()


