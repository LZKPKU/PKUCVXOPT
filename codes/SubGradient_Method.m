function [x,out] = SubGradient_Method(x0,A,b,mu,opts)
%Subgradient Method
[m,n] = size(A);
Maxitr = 1000;
x0 =zeros(n,1);
tol = 1e-6;
thres = 1e-6;
mu_ori = mu;
mu = mu*1e5;
ATA = A'*A;
ATb = A'*b;
% calculate subgradient
m = 1;
while mu>=mu_ori
    k = 0;
    sg = ones(n,1);
    mui = ones(n,1)*mu;
    if m<4
        Maxitr = 600;
    else Maxitr = 1500;
    end
while norm(sg)>=tol && k<=Maxitr
    k=k+1;
    stepsize = 0.035/(k+10);
    %update x
    % calculate subgradient
    sg = ATA*x0-ATb;
    sg(x0>thres) = sg(x0>thres)+mui(x0>thres);
    sg(x0<-thres) = sg(x0<-thres)-mui(x0<-thres);
  
    x0 = x0-sg*stepsize;  
end
    mu = mu/10;
    m = m+1;
end
x = x0;
out = 0.5*norm(A*x-b,2)^2+mu_ori*norm(x,1);


end

