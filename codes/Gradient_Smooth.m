function [x,out] = Gradient_Smooth(x0, A, b, mu, opts)
% Gradient method for Smoothed problem
% fixed stepsize

[m,n] = size(A);
ATA = A'*A;
ATb = A'*b;
% tuning parameter
thres = 1e-6;
Maxitr = 300;
% continuous strategy
mu_ori = mu;
mu = mu*1e5;
% optimal stepsize
step_size = 1/max(eig(ATA)); 
while mu>=mu_ori
    one = mu*ones(n,1);
    for k= 1:Maxitr
        tmp = (mu/thres)*x0;
        grid = ATA*x0-ATb + tmp;
        geq = x0>thres;
        leq = x0<-thres;
        grid(geq) = grid(geq) - tmp(geq) + one(geq);
        grid(leq) = grid(leq) - tmp(leq) - one(leq);
        x0 = x0-step_size*grid;  
        if  norm(grid) < thres
            break;
        end
    end   
    mu = mu/10;
end
% output
x = x0;
out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end
