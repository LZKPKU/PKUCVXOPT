function [x,out] = Projection_Gradient_Method(x0,A,b,mu,opts)
% Projection Gradient Method

% hyper parameter
[m,n] = size(A);
mu_ori = mu;
mu = mu*1e5;

tol = 1e-3;
% initialization
ATA = A'*A; 
ATb = A'*b;
B = [ATA,-ATA;-ATA,ATA];

z=ones(2*n,1);
z = [x0;-x0];
% Projection
z(z>0) = z(z>0);
z(z<=0) = 0;
while mu>=mu_ori
g = ones(2*n,1);
c =[-ATb+mu*ones(n,1);ATb+mu*ones(n,1)];
cnt = 0;
% test for terminate iteraion
while norm(g)>tol && cnt<=100
    Gd = c+B*z;% gradient of F(z)
    g = zeros(2*n,1);
    g(Gd<=0) = Gd(Gd<=0);
    g(z>0) = Gd(z>0);
    % calculate stepsize directly
    step_size = (z'*B*g+c'*g)/(g'*B*g);
    tmp = z-step_size*g;
    z = zeros(2*n,1);
    z(tmp>0) = tmp(tmp>0);
    cnt = cnt+1;

end
mu = mu/10;
end
% return optimal value
x = z(1:n)-z(n+1:2*n);
out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);

end

