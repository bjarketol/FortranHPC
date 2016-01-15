#!/usr/bin/env python
import numpy as np
from matplotlib import pyplot as plt
import seaborn as sns
import os 

def read_result(infile):
    p = [] 
    t = []
    with open(infile) as f:
        for line in f:
            print line.strip()
            pp, tw, tc, ts = line.strip().split()
            p.append(float(pp))
            t.append(float(tw))
    p = np.array(p)
    t = np.array(t)
    return p, t 

sns.set_context("talk", font_scale=2.0)

resultdir = "/home/btol/Dropbox/HPC/code/day7/poisson/results/"
fig = plt.figure(figsize=(12,8)) 
colors = ["r","g","b","y", "m"]
for ip, fname in enumerate(os.listdir(resultdir)):
    infile = os.path.join(resultdir,fname)
    p, t = read_result(infile)

    plt.plot(p,p,"k",lw=6.0)
    plt.plot(p,t[0]/t,"o",color=colors[ip],lw=10.0,label=fname.split("nstop")[0])
    plt.xticks([1] + range(0,21,2))
    plt.yticks([1] + range(0,21,2))
    plt.xlim([0.5,20.5])
    plt.ylim([0.5,20.5])


plt.legend(loc="upper left")
plt.show()









