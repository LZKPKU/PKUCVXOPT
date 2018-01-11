%Optimal Transport Problem
%N the scale of the problem
%minimize    \sum_{i=1}^n \sum{j=1}^n c_{ij}x_{ij}
%subject to  \sum_{j=1}^n x_{ij} = mu_i, i=1,2,...N;
%            \sum_{i=1}^n x_{ij} = nu_j, j=1,2,...N;
%            x_{ij} \geq 0 ,i,j=1,2,...N

% Size
n = 32;
N = n*n;

%Generate Parameters
C = rand(N,N);
mu = rand(N,1);
nu = rand(N,1);
mu(N) = 1 - sum(mu) + mu(N);
nu(N) = 1 - sum(nu) + nu(N);

%measuring error
errfun = @(x1, x2) norm(x1-x2)/(1+norm(x1));

%CVX calling Gurobi
tic;
[x0,out0] = OT_CVX_GRB(N,C,mu,nu);
t0 = toc;

%Calling Gurobi directly
tic;
[x1,out1] = OT_Gurobi(N,C,mu,nu);
t1 = toc;

%ADMM
tic;
[x2,out2] = OT_ADMM(N,C,mu,nu);
t2 = toc;

%Transportation Simplex
tic;
[x3,out3] = OT_Simplex(N,C,mu,nu);
t3 = toc;

%Multiscale method
tic;
[x4,out4] = OT_Multiscale(N,C,mu,nu);
t4 = toc;

% print comparison results with CVX call Gurobi
fprintf('  Call gurobi directly: cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t1, errfun(x0, x1));
fprintf('           ADMM Method: cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t2, errfun(x0, x2));
fprintf('Transportation Simplex: cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t3, errfun(x0, x3));
fprintf('     Multiscale Method: cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t4, errfun(x0, x4));

