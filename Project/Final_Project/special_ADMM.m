function [ x,out ] = special_ADMM( Model )
c = Model.c;
bl = Model.bl;
bu = Model.bu;
tl = Model.tl;
tu = Model.tu;
A = Model.A;
[m,n] = size(A);

rho = 1.618;
Maxitr = 2500;
x = zeros(n,1);
s1 = zeros(m,1);
s2 = zeros(m,1);
z = zeros(n,1);
lambda1 = zeros(m,1);
lambda2 = zeros(m,1);
lambda3 = zeros(n,1);
L = chol(2*(A'*A)+eye(n),'lower');
L = sparse(L);
U = sparse(L');
for i=1:Maxitr
    x =  U\(L\(A'*(-s1+bl-s2+bu)+z-(c+A'*(lambda1+lambda2)+lambda3)/rho));
    s1 = bl-A*x-lambda1/rho;
    s1(s1>=0) = 0;
    s2 = bu-A*x-lambda2/rho;
    s2(s2<=0) = 0;
    z = phi(x+lambda3/rho,tl,tu);
    lambda1 = lambda1+rho*(A*x+s1-bl);
    lambda2 = lambda2+rho*(A*x+s2-bu);
    lambda3 = lambda3+rho*(x-z);
end
out = c'*x;
end

function[result] = phi(x,l,u)
    result = x;
    result(x<=l) = l(x<=l);
    result(x>=u) = u(x>=u);  
end

