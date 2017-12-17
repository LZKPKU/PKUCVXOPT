function [x, out] = ADMM_Dual(x0, A, b, mu, opts)
% Alternating direction method of multipliers for Dual Problem
[m,n]= size(A);
% continuous strategy
mu_ori = mu;
mu = mu*1e5;
% parameter
Maxitr = 30;
rho = 1.618;

x = x0;
z = zeros(m,1);
u = x;
% cholesky decomposition to accelerate calculation
L = chol(speye(m)+rho*A*A','lower');
L = sparse(L);
U = sparse(L');
ATz = A'*z;
% continuous strategy
while mu>=mu_ori
    for k = 1:Maxitr
        %threshold for u
        u = ATz-x/rho;
        u(u>mu) = mu;
        u(u<-mu) = -mu;
        z = U\(L\(A*x-b+rho*A*u));
        ATz = A'*z;
        x = x + rho*(u-ATz);
    end
    mu = mu/10;
end
out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);

end

