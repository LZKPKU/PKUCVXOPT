function [x,out] = Fast_Proximal_Gradient(x0,A,b,mu,opts)
% Fast Proximal Gradient Method
% fixed stepsize

[m,n] = size(A);
ATA = A'*A;
ATb = A'*b;
% tuning parameter
thres = 1e-4;
Maxitr = 40;
% continuous strategy
mu_ori = mu;
mu = mu*1e5;
% xpp prepre step x  
% xp pre step x
xp = x0;
xpp = xp;
step_size = 1/max(eig(ATA));

while mu>=mu_ori
    k = 2;
    gridy = ones(n,1);
    while k<= Maxitr && norm(gridy)>= thres
        k = k+1;
        % FISTA step 1
        y = xp+(k-2)*(xp-xpp)/(k+1);
        gridy = ATA*y - ATb;
        
        tmpx = y-step_size*gridy;
        tmp = step_size*mu;
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

