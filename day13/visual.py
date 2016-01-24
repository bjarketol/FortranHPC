#!/usr/bin/env python
import numpy as np
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm

files = ["out/output00.dat",
         "out/output01.dat",
         "out/output02.dat",
         "out/output03.dat"]

nam = [0,1,2,3]

d = {}

for i, ifile in enumerate(files): 
    with open(ifile) as f:
        data = np.genfromtxt(f) 

    temp = np.reshape(data[:, 2], (30, 30))
    x = np.reshape(data[:, 0], (30, 30)) 
    y = np.reshape(data[:, 1], (30, 30))
    
    d[str(nam[i])] = {}
    d[str(nam[i])]["temp"] = temp
    d[str(nam[i])]["x"] = x
    d[str(nam[i])]["y"] = y

    fig = plt.figure(figsize=(12,8))
    ax = fig.add_subplot(1, 1, 1, projection='3d')

    #surf = ax.plot_wireframe(x, y, temp, color="r")
    surf = ax.plot_surface(x, y, temp,
                          rstride = 1,
                          cstride = 1,
                          cmap=cm.coolwarm,
                          linewidth=0,
                          antialiased=False)

    #ax.set_zlim3d(0.8, 1)

    #plt.show()


t1 = np.vstack([d["0"]["temp"],d["1"]["temp"]])
t2 = np.vstack([d["2"]["temp"],d["3"]["temp"]])
x1 = np.vstack([d["0"]["x"],d["1"]["x"]])
x2 = np.vstack([d["2"]["x"],d["3"]["x"]])
y1 = np.vstack([d["0"]["y"],d["1"]["y"]])
y2 = np.vstack([d["2"]["y"],d["3"]["y"]])

temp = np.hstack([t1,t2])
x = np.hstack([x1,x2])
y = np.hstack([y1,y2])

#temp = np.reshape(ta, (60, 60))
#x = np.reshape(xa, (60, 60)) 
#y = np.reshape(ya, (60, 60))

fig = plt.figure(figsize=(12,8))
ax = fig.add_subplot(1, 1, 1, projection='3d')

#surf = ax.plot_wireframe(x, y, temp, color="r")
surf = ax.plot_surface(x, y, temp,
                       rstride = 1,
                       cstride = 1,
                       cmap=cm.coolwarm,
                       linewidth=0,
                       antialiased=False)

#ax.set_zlim3d(0.8, 1)

plt.show()


