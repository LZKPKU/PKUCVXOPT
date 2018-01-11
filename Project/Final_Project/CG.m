function [x] =CG(A,b)
% ¹²éîÌÝ¶È·¨
tol = 1e-6;
Maxitr=1000;
[m,n] = size(A);
x0 = 0.1*ones(n,1);
r = b-A*x0;
lo = r'*r;
k=0;
% stop condition
while sqrt(lo)>tol*norm(b) && k < Maxitr
    k=k+1;
    if k==1
        p = r;
    else
        beta = lo/lol;
        p = r+beta*p;
    end
    temp = A*p;
    alpha = lo/(p'*temp);
    x0 = x0+alpha*p;
    r = r - alpha*temp;
    lol = lo;
    lo = r'*r;
end

x = x0;
num = k;
end

