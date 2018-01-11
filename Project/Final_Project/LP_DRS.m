function [x,out] = LP_DRS( c,A,b,opts,x0 )
%2a(1) 
%Douglas Rachford Splitting(DRS) method for Primal Problem
[m,n] = size(A);
t = 0.005;
tol1 = 1e-10;
tol2 = 1e-10;
x = x0;
z = zeros(n,1);
B = A'/(A*A');
err = 1;
while norm(A*x-b) > tol1 || abs(err)>tol2
    xp = x;
    x = z - t * c;
    x(x<=0) = 0;
    z = x + B*(b-A*(2*x-z));
    err = c'*(xp-x)/(c'*x);
end
out = c'*x;
end
