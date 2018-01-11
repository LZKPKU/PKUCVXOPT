function[x,out]=LP_Netlib_ADMM(Model)
if strcmp(Model.sense,'minimize')
     c = Model.obj;
else
     c = -Model.obj;
end
tl = Model.lb;
tu = Model.ub;
bl = Model.lhs;
bu = Model.rhs;
A = Model.A;
[m,n] = size(A);

rho = 1.618;
Maxitr = 2000;
x = zeros(n,1);
s1 = zeros(m,1);
s2 = zeros(m,1);
z = zeros(n,1);
lambda1 = zeros(m,1);
lambda2 = zeros(m,1);
lambda3 = zeros(n,1);
H = 2*(A'*A)+eye(n);
for i = 1:Maxitr
    x =  H\(A'*(s1+bl-s2+bu)+z-(c+A'*(lambda1+lambda2)+lambda3)/rho);
    s1 = phi0(-bl+A*x+lambda1/rho);
    s2 = phi0(bu-A*x-lambda2/rho);
    z = phi(x+lambda3/rho,tl,tu);
    lamdba1 = phi0(lambda1+rho*(A*x-bl));
    lambda2 = phi0(lambda2+rho*(A*x-bu));
    lambda3 = psi(lambda3+rho*x,rho*tl,rho*tu);
end
out = c'*x;
end

function[result]=phi0(x)
    result = x;
    result(x<=0) = 0;
end

function[result] = phi(x,l,u)
    result = x;
    result(x<=l) = l(x<=l);
    result(x>=u) = u(x<=l);  
end

function[result] = psi(x,l,u)
    result = 0;
    result(x<l) = x(x<l)-l(x<l);
    result(x>u) = x(x>u)-u(x<l);
end

