function [ x3,out3 ] = l1_mosek(x0,A,b,mu,opts3)
%直接调用Mosek求解
[m,n] = size(A);
%二阶项矩阵
q = [0.5*A'*A,zeros(n,n);zeros(n,n),zeros(n,n)];
%变形后的一次项矩阵
c = [zeros(n,1);mu*ones(n,1)];
%约束系数矩阵
a = [eye(n),eye(n);-eye(n),eye(n)];
u = A\b;
%约束值矩阵
blc = [-u;u];
results = mskqpopt(q,c,a,blc,[],[],[],[],'minimize');
% 返回值
x3 = results.sol.itr.xx(1:n)+u;
out3 = results.sol.itr.pobjval;
end