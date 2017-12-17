function [x,out] = Fast_Gradient_Smooth(x0, A, b, mu, opts)
% Fast Gradient method for Smoothed problem
% fixed stepsize
[m,n] = size(A);
ATA = A'*A;
ATb = A'*b;
% tuning parameter
thres = 1e-6;
Maxitr = 100;
% continuous strategy
mu_ori = mu;
mu = mu*1e5;
% xpp prepre step x  
% xp pre step x
xp = x0;
xpp =xp;
step_size = 1/max(eig(ATA)); 

while mu>=mu_ori
    one = mu*ones(n,1);
    for k= 1:Maxitr
        y = xp+(k-2)*(xp-xpp)/(k+1);
        tmp = (mu/thres)*y;
        gridy = ATA*y-ATb + tmp;
        geq = y>thres;
        leq = y<-thres;
        gridy(geq) = gridy(geq) - tmp(geq) + one(geq);
        gridy(leq) = gridy(leq) - tmp(leq) - one(leq);
       
        x0 = y - step_size*gridy;
        if  norm(gridy) < thres
            break;
        end
        xpp = xp;
        xp =x0;
    end   
    mu = mu/10;
end
% output
x = x0;
out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end
