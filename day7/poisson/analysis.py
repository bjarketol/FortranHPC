#!/usr/bin/env python
from __future__ import division
import numpy as np
from matplotlib import pyplot as plt
import seaborn as sns
import os 
from scipy.optimize import curve_fit

def amdahl(x,f):
    return 1/(1-f+f/x)

def read_result(infile):
    p = [] 
    t = []
    with open(infile) as f:
        for line in f:
            pp, tw, tc, ts = line.strip().split()
            p.append(float(pp))
            t.append(float(tw))
    p = np.array(p)
    t = np.array(t)
    return p, t 

sns.set_context("talk", font_scale=2.0)

resultdir = "/home/btol/Dropbox/HPC/code/day7/poisson/results/"
fig = plt.figure(figsize=(12,8)) 
colors = sns.color_palette()
sizes = {"n101" : 0.23348, 
         "n1001" : 22.93398, 
         "n2001" : 91.64431, 
         "n5001" : 572.43349, 
         "n10001" : 2289.27615}

for ip, fname in enumerate(sorted(os.listdir(resultdir))):

    if ip in [1,3]:
        continue

    infile = os.path.join(resultdir,fname)
    p, t = read_result(infile)

    y = t[0]/t

    xdata = p
    ydata = y

    popt, pcov = curve_fit(amdahl,xdata,ydata)
    f = popt[0]

    yl = amdahl(p,f)

    plt.plot(p,yl,ls="--",lw=4.0,alpha=0.7,color=colors[ip])
    plt.plot(p,p,"k",lw=6.0)
    plt.plot(p,y,
             "o",
             color=colors[ip],
             alpha=0.7,
             ms=15.0,
             label="%.1f Mb (f = %.3f)" % (sizes[fname.split("nstop")[0][1:]],f))
    plt.xticks([1] + range(0,21,2))
    plt.yticks([1] + range(0,21,2))
    plt.xlim([0.5,20.5])
    plt.ylim([0.5,20.5])

plt.ylabel("Speedup factor")
plt.xlabel("Processors")
plt.legend(loc="upper left")
plt.tight_layout()
plt.savefig("/home/btol/Desktop/fig.png")
plt.show()









