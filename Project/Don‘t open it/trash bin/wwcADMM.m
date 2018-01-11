% Size
n = 3;
N = n*n;

%Generate Parameters
C = rand(N,N);
mu = rand(N,1);
nu = rand(N,1);
mu = mu/sum(mu);
nu = nu/sum(nu);

%Using ADMM to solve Optimal Transport Problem
x = sparse(zeros(N*N,1));
C = reshape(C',[],1);
A = zeros(2*N,N*N);
z = x;
lambda = sparse(zeros(2*N,1));
eta = sparse(zeros(N*N,1));
rho = 1.618;
Maxitr = 1000;
b = [mu;nu];
%Construct A
for i=1:N
    A(i,(1+N*(i-1)):N+N*(i-1))=1;
end
for i=1:N
    for j=1:N
        A(N+i,i+N*(j-1))=1;
    end
end
%A = sparse(A);
ATb = A'*b;
L = sparse(chol(A'*A+eye(N*N)));
U = sparse(L');
for iter=1:Maxitr
    %x = L\(U\(ATb+z-(C+A'*lambda+eta)/rho));
    x = (A'*A+eye(N*N))\(ATb+z-(C+A'*lambda+eta)/rho);
    z = zeros(N*N,1);
    tmp = x + eta/rho;
    z(tmp>0) = tmp(tmp>0);
    lambda = lambda + rho*(A*x-b);
    eta = eta + rho * (x-z);
end
out = C'* x;