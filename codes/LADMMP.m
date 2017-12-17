function [x, out] = LADMMP(x0,A, b, mu, opts)
% Linearized ADMM for primal
[m, n] = size(A);
% parameter
rho =1.618;
eta = max(eig(A'*A));
Maxitr = 800;
% continuous strategy
mu_ori = mu;
mu = mu*1e5;

x = x0;
u = zeros(n,1);
lambda = zeros(n,1);

ATb = A'*b;
ATA = A'*A;

while mu>=mu_ori
    for k = 1:Maxitr
        x = (ATb+rho*u-lambda-ATA*x+eta*x)/(eta+rho);
        t = mu/rho;
        tt = x+lambda/rho;
        u = max(0,tt-t)-max(0,-tt-t);

        lambda = lambda + rho*(x-u);
    end
    mu = mu/10;
end
out  = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end

