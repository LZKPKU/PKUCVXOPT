function [x,out] = Mosek(c,A,b,opts,x0)
% ֱ�ӵ���Mosek������Թ滮��׼��ʽ
[m,n] = size(A);
l = zeros(1,n);

x = linprog(c',[],[],A,b,l);
out = c'*x;

end

