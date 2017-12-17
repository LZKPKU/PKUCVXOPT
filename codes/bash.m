load data.mat
[m,n] = size(A);
name = {};
b_Gurobi = zeros(n*2,n*2);
rhs = [];
for i=1:n
    name{i}=strcat('x',num2str(i));
    name{i+n}=strcat('t',num2str(i));
    b_Gurobi(i,i)=1;
    b_Gurobi(i+n,i)=-1;
    b_Gurobi(i,i+n)=1;
    b_Gurobi(i+n,i+n)=1;
    rhs(i)= -u(i);
    rhs(i+n) = u(i);
end

A_Gurobi = [0.5*A'*A,zeros(n,n);zeros(n,n),zeros(n,n)];
obj_Gurobi = [zeros(n,1);mu*ones(n,1)];

clear model;
model.varnames = name;
model.Q = sparse(A_Gurobi);
model.A = sparse(b_Gurobi);
model.rhs = rhs;
model.obj = obj_Gurobi;
model.sense='>';

results = gurobi(model);
