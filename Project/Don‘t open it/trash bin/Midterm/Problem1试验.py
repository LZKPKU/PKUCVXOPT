from gurobipy import *
import random
import time
# Create a new model

def model(Size_n,method,c):
    m1 = Model("mip1")
    # Create variables
    x=[0]

    for i in range(1,(Size_n*Size_n+1)):
        x.append(m1.addVar(vtype=GRB.BINARY))

    # Set objective
    Obj = LinExpr()
    for i in range(1,Size_n*Size_n+1):
        Obj += c[i] * x[i]
    m1.setObjective(Obj, GRB.MINIMIZE)

    # Add constraints
    for i in range(Size_n):
        Obj = LinExpr()
        for j in range(1,Size_n+1):
            Obj += x[i*Size_n+j]
        m1.addConstr(Obj == 1)
    for i in range(1,Size_n+1):
        Obj = LinExpr()
        for j in range(Size_n):
            Obj += x[i+j*Size_n]
        m1.addConstr(Obj == 1)

    start=time.clock()
    m1.Params.Method=0
    m1.optimize()
    end=time.clock()
    print('time:',end-start)

Size_n=1024
c=[0]
for i in range(1,Size_n*Size_n+1):
    c.append(random.uniform(0,1))
model(Size_n,0,c)
model(Size_n,1,c)