function [x,out] = RMSPropNM(x0, A, b, mu, opts)
% RMSProp algorithm with Nesterov momentum
[m,n] = size(A);
% subgradient threshold
thres = 1e-6;
%momentum coefficient 
alpha = 0.99;
% decay rate
rho = 0.99999;
% learning rate
epsilon = 0.01;
% continuous strategy
mu_ori = mu;
mu = mu*1e5;
% Maximum iteration number
Maxitr = 300;
r = zeros(n,1);
ATA = A'*A;
ATb = A'*b;

x = x0;
v = zeros(n,1);
while mu>=mu_ori
    mui = mu*ones(n,1);
    for k = 1:Maxitr
        % use the entire training set
        xhat = x+alpha*v;
        sg = ATA*xhat-ATb;
        sg(xhat>thres) = sg(xhat>thres)+mui(xhat>thres);
        sg(xhat<-thres) = sg(xhat<-thres)-mui(xhat<-thres);
        sub = sg/m;
        r = rho*r + (1-rho)*sub.*sub;
        stepsize = (-epsilon)./(sqrt(r));  
        v = alpha*v + stepsize.*sub;
        x = x + v;
        
        %0.5*norm(A*x-b)^2 + mu_ori*norm(x,1)         
    end
    mu = mu/10;
end

out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end

