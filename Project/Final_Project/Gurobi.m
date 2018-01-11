function [x,out] = Gurobi(c,A,b,opts,x0)
% ֱ�ӵ���Gurobi������Թ滮��׼��ʽ
[m,n] = size(A);

for i=1:n
    name{i}=strcat('x',num2str(i));
end

clear model;
params.outputflag = 0;
model.varnames = name;
model.A = sparse(A);
model.obj = c';
model.rhs = b';
model.sense = '=';
model.lb = zeros(1,n);

results = gurobi(model,params);

out = results.objval;
x = results.x;


end

