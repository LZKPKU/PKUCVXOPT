%Test bash
%This code is designed to test the ADMM that is especially designed for the
%following form of LP:
%min  c'x
%s.t. bl <= Ax <=bu
%     tl <= x  <=tu

%CVX_Gurobi is used as ground truth
%Two algorithms are tested:
%(1) ADMM after transforming the problem into the standard form;
%       (trans_ADMM)
%(2) ADMM that is especially desgined for the problem
%       (special_ADMM)

%Generate Random Data
n = 50;		
m = 10;		
Model.A = rand(m,n);		
Model.xs = full(abs(sprandn(n,1,m/n)));		
b = Model.A*xs;		
y = randn(m,1);		
s = rand(n,1).*(xs==0);		
Model.c = Model.A'*y + s;	
delta1 = rand(m,1);
Model.bl = b - delta1;
Model.bu = b + delta1;
delta2 = rand(n,1);
Model.tl = xs - delta2;
Model.tu = xs + delta2;

% Measuring Error		
errfun = @(x1, x2) abs(x1-x2);

%Ground Truth: CVX_Gurobi
tic;
[x0,out0] = special_CVX_Gurobi(Model);
t0 = toc;

%ADMM for the transformed problem
tic;
[x1,out1] = trans_ADMM(Model);
t1 = toc;

%ADMM for the special form
tic;
[x2,out2] = special_ADMM(Model);
t2 = toc;

fprintf('Transformed ADMM : cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t1, errfun(out0, out1));
fprintf('    Special ADMM : cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t2, errfun(out0, out2));