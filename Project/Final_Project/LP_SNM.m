function [x,out] = LP_SNM( c,A,b,opts,x0 )
%2(c)
%Semi-smooth Newton Method(SNM)
[m,n] = size(A);

%parameters
t = 0.1;
Maxitr = 15000;
tol1 = 1e-10;
tol2 = 1e-10;
v = 0.9;
eta1 = 0.1;
eta2 = 0.9;
gamma1 = 1.5;
gamma2 = 10;
lambda = 0.01;
err = 1;

%initialization
x = x0;
z = zeros(n,1);
u = zeros(n,1);
lambdak = 1;
AAT = A*A';

beta = eye(n)-A'/(AAT)*A;
alpha = A'/(AAT)*b;
k = 0;

while (norm(A*x-b) > tol1 || abs(err)>tol2) && k < Maxitr
    %update x
    xp = x;
    x = z - t * c;
    x(x<=0) = 0;
    err = c'*(xp-x)/(c'*x);
    %update z and u
    f = x - (beta*(2*x-z)+alpha);
    e = sign(x);
    E = diag(e);
    J = E - beta*(2*E-eye(n));
    muk = lambdak * norm(f);
    Jp = J + muk*eye(n);
    dk = -Jp\f;
    uk = z + dk;
    fuk = x - (beta*(2*x-uk)+alpha);
    rhok = -(fuk'*dk)/(norm(dk)^2);
    fu = x - (beta*(2*x-u)+alpha);
    if rhok >= eta1
        if norm(fuk)<= v * norm(fu)
            z = uk;
            u = uk;
        else
            z = z - (fuk'*(z-uk)/(norm(fuk)^2))*fuk; 
        end
    end
    %update lambda
    if rhok >= eta2
        lambdak = (lambda+lambdak)/2;
    elseif rhok < eta1
        lambdak = lambdak*(gamma1+gamma2)/2;
    else
        lambdak = lambdak*(gamma1+1)/2;
    end
    k = k + 1;
end
out = c'*x;
end

