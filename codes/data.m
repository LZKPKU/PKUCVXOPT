n = 1024;
m = 512;
A = randn(m,n);
u = sprandn(n,1,0.1);
b = A*u;
mu = 1e-3;
x0 = rand(n,1);

errfun = @(x1, x2) norm(x1-x2)/(1+norm(x1));