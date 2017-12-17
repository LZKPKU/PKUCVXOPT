function [x,out] = Adam(x0, A, b, mu, opts)
% Adam algorithm
[m,n] = size(A);
% numerical stabilization constant
delta = 1e-8;
% subgradient threshold
thres = 1e-6;
% Exponential decay rate
rho1 = 0.99;
rho2 = 0.999;
% Step size
epsilon = 0.08;
% continuous strategy
mu_ori = mu;
mu = mu*1e5;
% Maximum iteration number
Maxitr = 500;

x = x0;
ATA = A'*A;
ATb = A'*b;
t = 0;
% initialize 1st and 2nd moment variables
s = zeros(n,1);
r = zeros(n,1);
while mu>=mu_ori
    mui = mu*ones(n,1);
    for k = 1:Maxitr
        % use the entire training set
        sg = ATA*x-ATb;
        sg(x>thres) = sg(x>thres)+mui(x>thres);
        sg(x<-thres) = sg(x<-thres)-mui(x<-thres);
        sub = sg/m;
        % update t
        t = t + 1;
        s = rho1*s + (1-rho1)*sub;
        r = rho2*r + (1-rho2)*sub.*sub;
        
        shat = s/(1-rho1^t);
        rhat = r/(1-rho2^t);
        
        stepsize = shat./(sqrt(rhat)+delta);  
        
        x = x - epsilon*stepsize;
        
        %0.5*norm(A*x-b)^2 + mu_ori*norm(x,1)         
    end
    mu = mu/10;
end

out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end

