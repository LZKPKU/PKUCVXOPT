function [x,out] = LP_ADMM( c,A,b,opts,x0 )
%2(a)
%Alternative Direction Method of Multipliers(ADMM) for Dual Problem
[m,n] = size(A);
y = zeros(m,1);
step_size = 1/max(eig(A'*A));
rho = 1.618;
tol1 = 1e-10;
tol2 = 1e-10;
x = x0;
xp = x0;
err = 1;
while norm(A*x-b) > tol1 || abs(err)>tol2
    %update y
    y = y + (A*A')\(A*(xp-2*x)+b);
    %update x
    xp = x;
    x = x + rho * (A' * y - c);
    x(x <= 0) = 0;
    err = c'*(xp-x)/(c'*x);
end
out = c'*x;
end
