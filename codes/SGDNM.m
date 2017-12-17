function [x,out] = SGDNM(x0, A, b, mu, opts)
% Stochastic gradient descent with Nesterov momentum
[m,n] = size(A);
% subgradient threshold
thres = 1e-6;
% continuous strategy
mu_ori = mu;
mu = mu*1e5;
%momentum coefficient
alpha = 0.99;
% learning rate
epsilon = 0.01;
ATA = A'*A;
ATb = A'*b;
% Maximum iteration number
Maxitr = 300;

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
        
        v = alpha*v-epsilon*sub;
        x = x+v;
        %0.5*norm(A*x-b)^2+mu_ori*norm(x,1)
    end
mu = mu/10;
end
out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end


