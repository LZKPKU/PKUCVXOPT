function [x4, out4] = l1_gurobi(x0, A, b, mu, opts4)
% 直接调用Gurobi求解
clear model;
[m,n] = size(A);

name = {};%变量名称
b_Gurobi = [-eye(n),eye(n);eye(n),eye(n)];%约束系数矩阵
rhs = zeros(2*n,1);%约束常数矩阵
%利用循环创建变量
for i=1:n
    name{i}=strcat('x',num2str(i));
    name{i+n}=strcat('t',num2str(i));
end
%二次项矩阵，x的系数为0.5*A^TA，t的系数为0
A_Gurobi = [0.5*A'*A,zeros(n,n);zeros(n,n),zeros(n,n)];
%一次项矩阵,x的系数为0,t的系数为mu
obj_Gurobi = [-(A'*b);mu*ones(n,1)];

clear model;
model.varnames = name;
model.Q = sparse(A_Gurobi);
model.A = sparse(b_Gurobi);
model.rhs = rhs;
model.obj = obj_Gurobi;
model.sense='>';
model.lb=-inf*ones(2*n,1);

results = gurobi(model);

out4 = results.objval+0.5*b'*b;
x4 = results.x(1:n);

end

