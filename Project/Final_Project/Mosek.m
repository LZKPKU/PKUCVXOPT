function [x,out] = Mosek(c,A,b,opts,x0)
% 直接调用Mosek求解线性规划标准形式
[m,n] = size(A);
l = zeros(1,n);

x = linprog(c',[],[],A,b,l);
out = c'*x;

end

