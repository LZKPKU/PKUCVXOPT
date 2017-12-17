function [x,out] = Proximal_Gradient(x0, A, b, mu, opts)
% Projection Gradient Method
[m,n] = size(A);
thres = 1e-4;
Maxitr = 250;
ATA = A'*A;
ATb = A'*b;
mu_ori = mu;
mu = mu*1e5;
step_size = 1/max(eig(ATA));

% continuous strategy
while mu>=mu_ori
    k=0;
    grid = ATA*x0-ATb;
    while norm(grid)>=thres && k<=Maxitr
        k = k+1;
        grid = ATA*x0-ATb;
        
        x1 = x0 - step_size*grid;
        tmp = step_size*mu;
        x0 = zeros(n,1);
        % proximal mapping
        x0(x1>tmp) = x1(x1>tmp)-tmp;
        x0(x1<-tmp) = x1(x1<-tmp)+tmp;
    end
    mu = mu/10;
end
%output
x = x0;
out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end

