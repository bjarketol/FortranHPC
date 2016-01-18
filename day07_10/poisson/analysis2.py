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

sns.set_context("talk", font_scale=1.9)

resultdir = "/home/btol/Dropbox/HPC/code/day7/poisson/results3/"
fig = plt.figure(figsize=(12,9)) 
colors = sns.color_palette()

sizes = {"n31" : 0.022,
         "n41" : 0.0,
         "n61" : 0.0,
         "n81" : 0.15017,
         "n101" : 0.23348, 
         "n1001" : 22.93398, 
         "n2001" : 91.64431, 
         "n5001" : 572.43349, 
         "n10001" : 2289.27615}

items = ["Optimized.txt",
         "Unoptimized.txt"]
tt = 24.78
for ip, fname in enumerate(items):


    infile = os.path.join(resultdir,fname)
    p, t = read_result(infile)

    y = t[0]/t

    xdata = p
    ydata = y

    popt, pcov = curve_fit(amdahl,xdata,ydata)
    f = popt[0]

    yl = amdahl(p,f)
        
    yy = tt/t

    if ip == 0:
        plt.plot(p,yy,"*",ms=20.0,alpha=0.7, label="%s relative to Unoptimized" % fname[:-4])
    plt.plot(p,yl,ls="--",lw=4.0,alpha=0.7,color=colors[ip])
    plt.plot(p,p,"k",lw=6.0)
    plt.plot(p,y,
             "o",
             color=colors[ip],
             alpha=0.7,
             ms=15.0,
             label = "%s" % fname[:-4]
             #label="N=%s (f = %.3f) [%.2f MB]" % (fname.split("nstop")[0].split("n")[1],f,sizes[fname.split("nstop")[0][1:]]))
            )
    plt.xticks([1] + range(0,21,2))
    plt.yticks([1] + range(0,31,2))
    plt.xlim([0.5,20.5])
    plt.ylim([0.5,30.5])

plt.ylabel("Speedup factor")
plt.xlabel("Processors")
plt.legend(loc="upper left")
plt.tight_layout()
plt.savefig("/home/btol/Dropbox/HPC/reports/week2/optimize.pdf")
plt.show()









