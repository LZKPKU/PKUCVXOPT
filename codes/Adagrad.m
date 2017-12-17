function [x,out] = Adagrad(x0, A, b, mu, opts)
% Adagrad method
[m,n] = size(A);
% numerical stabilization constant
delta = 1e-7;
% subgradient threshold
thres = 1e-6;
% learning rate
epsilon = 2;
% continuous strategy
mu_ori = mu;
mu = mu*1e5;
% Maximum iteration number
Maxitr = 250;

x = x0;
ATA = A'*A;
ATb = A'*b;
r = zeros(n,1);
while mu>=mu_ori
    mui = mu*ones(n,1);

    for k = 1:Maxitr
        % use the entire training set
        sg = ATA*x-ATb;
        sg(x>thres) = sg(x>thres)+mui(x>thres);
        sg(x<-thres) = sg(x<-thres)-mui(x<-thres);
        sub = sg/m;
        r = r + sub.*sub;
        stepsize = (-epsilon)./(sqrt(r) + delta);  
        
        x = x+stepsize.*sub;
        %0.5*norm(A*x-b)^2 + mu_ori*norm(x,1)         
    end
    mu = mu/10;
end
out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);

end

