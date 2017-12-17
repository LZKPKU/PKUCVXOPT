function [x,out] = Fast_Proximal_Gradient_linesearch(x0,A,b,mu,opts)
% Fast Proximal Gradient Method
% FISTA

[m,n] = size(A);
ATA = A'*A;
ATb = A'*b;
% tuning parameter
thres = 1e-4;
Maxitr = 25;
% continuous strategy
mu_ori = mu;
mu = mu*1e5;
% backtracking line search
sigma = 0.1;
beta = 0.5;
% xpp prepre step x  
% xp pre step x
xp = x0;
xpp = xp;

while mu>=mu_ori
    k = 2;
    gridy = ones(n,1);
    while k<= Maxitr && norm(gridy)>= thres
        k = k+1;
        % FISTA step 1
        y = xp+(k-2)*(xp-xpp)/(k+1);
        gridy = ATA*y - ATb;
        %backtracking line search
        % alpha is step_size
        gridx = ATA*x0 - ATb;
        alpha = 1;
        obj0 = 0.5*norm(A*x0-b)^2;
        obj1 = 0.5*norm(A*(x0 - alpha*gridx)-b)^2;
        
         while obj1-obj0>-alpha*sigma*gridx'*gridx
            alpha = alpha*beta;
            obj1 = 0.5*norm(A*(x0 - alpha*gridx)-b)^2;
         end

        tmpx = y-alpha*gridy;
        tmp = alpha*mu;
        x0 = zeros(n,1);
       % proximal mapping ---- new x0
        x0(tmpx>tmp) = tmpx(tmpx>tmp)-tmp;
        x0(tmpx<-tmp) = tmpx(tmpx<-tmp)+tmp;
        xpp = xp;
        xp = x0;
    end
    % update mu
    mu = mu/10;    
end
%output
x= x0;
out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end

