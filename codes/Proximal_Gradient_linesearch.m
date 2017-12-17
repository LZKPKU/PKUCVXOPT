function [x,out] = Proximal_Gradient_linesearch(x0, A, b, mu, opts)
% Projection Gradient Method
[m,n] = size(A);
thres = 1e-2;
Maxitr = 70;
ATA = A'*A;
ATb = A'*b;
mu_ori = mu;
mu = mu*1e5;
sigma = 0.1;
beta = 0.5;
% continuous strategy
while mu>=mu_ori
    k=0;
    grid = ATA*x0-ATb;

    while norm(grid)>=thres && k<=Maxitr
        k = k+1;
        grid = ATA*x0-ATb;
        alpha = 1;
        obj0 = 0.5*norm(A*x0-b)^2;
        x1 = x0 - alpha*grid;
        obj1 = 0.5*norm(A*x1-b)^2;
        % backtracking line search
        while obj1-obj0>-alpha*sigma*grid'*grid
            alpha = alpha*beta;
            x1 = x0 - alpha*grid;
            obj1 = 0.5*norm(A*x1-b)^2;
        end
       tmp = alpha*mu;
       x0 = zeros(n,1);
       % proximal mapping
       x0(x1>tmp) = x1(x1>tmp)-tmp;
       x0(x1<-tmp) = x1(x1<-tmp)+tmp;
       %0.5*norm(A*x1-b)^2+mu_ori*norm(x1,1)
    end
    mu = mu/10;
end
%output
x = x0;
out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end
