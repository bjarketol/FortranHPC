import numpy as np

N = 100

A = np.zeros([N,N])
B = np.zeros([N,N])


for i in xrange(N):
    for j in xrange(N):
        A[i,j] = np.cos(i*N+j)
        B[i,j] = np.cos(i*N+j)


C = np.dot(A,B)

print sum(A[50:100,99]*B[98,50:100]) + sum(A[0:50,99]*B[98,0:50])

print A[95:100,99]
print B[98,95:100]
print A[45:50,99]
print B[98,45:50]


#print np.sum(A[50:100,98]*B[99,50:100])+np.sum(A[50:100,48]*B[49,50:100])

#print A[98:100,98:100]
#print B[98:100,98:100]
#print C[98100,98:100]

#print A[2:4,2:4]
#print B[2:4,2:4]
#print C
#print C[2:4,2:4]
#

#print A[50:100,50:100], B[50:100,50:100]
c0 = np.dot(A[50:100,50:100],B[50:100,50:100])
c1 = np.dot(A[50:100,0:50],B[0:50,50:100])

#print (c0+c1)[48,49]

