function [x4, out4] = l1_gurobi(x0, A, b, mu, opts4)
% ֱ�ӵ���Gurobi���
clear model;
[m,n] = size(A);

name = {};%��������
b_Gurobi = [-eye(n),eye(n);eye(n),eye(n)];%Լ��ϵ������
rhs = zeros(2*n,1);%Լ����������
%����ѭ����������
for i=1:n
    name{i}=strcat('x',num2str(i));
    name{i+n}=strcat('t',num2str(i));
end
%���������x��ϵ��Ϊ0.5*A^TA��t��ϵ��Ϊ0
A_Gurobi = [0.5*A'*A,zeros(n,n);zeros(n,n),zeros(n,n)];
%һ�������,x��ϵ��Ϊ0,t��ϵ��Ϊmu
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

