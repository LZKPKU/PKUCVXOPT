function [x, out] = ADMMP(x0,A, b, mu, opts)
% ADMM for Primal Problem
[m,n] = size(A);
% Lagrangian parameter
rho =1.618;
% continuous
mu_ori = mu;
mu = mu*1e5;
Maxitr = 25;

x = x0;
u = zeros(n,1);
lambda = zeros(n,1);
% cholesky decomposition 
L = chol(rho*eye(n)+A'*A,'lower');
L = sparse(L);
U = sparse(L');
ATb = A'*b;

while mu>=mu_ori
    t = mu/rho;
    for k = 1:Maxitr

        x = U\(L\(ATb+rho*u-lambda));

        tmp = x+lambda/rho;
        geq = tmp>t;
        leq = tmp<-t;
        u = zeros(n,1);
        u(geq) = tmp(geq)-t;
        u(leq) = tmp(leq)+t;

        lambda = lambda + rho*(x-u);
    end
    mu = mu/10;
end
out  = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end