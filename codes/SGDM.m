function [x,out] = SGDM(x0, A, b, mu, opts)
% Stochastic gradient descent with momentum
[m,n] = size(A);
% subgradient threshold
thres = 1e-6;
% continuous strategy
mu_ori = mu;
mu = mu*1e5;
%momentum coefficient
alpha = 0.99;
% learning rate
epsilon = 0.02;
ATA = A'*A;
ATb = A'*b;
% Maximum iteration number
Maxitr = 500;

x = x0;
v = zeros(n,1);

while mu>=mu_ori
    mui = mu*ones(n,1);
    for k = 1:Maxitr
         % use the entire training set
        sg = ATA*x-ATb;
        sg(x>thres) = sg(x>thres)+mui(x>thres);
        sg(x<-thres) = sg(x<-thres)-mui(x<-thres);
        sub = sg/m;
        
        v = alpha*v-epsilon*sub;
        x = x+v;
        %0.5*norm(A*x-b)^2+mu_ori*norm(x,1)
    end
mu = mu/10;
end
out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end

