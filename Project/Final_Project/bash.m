load test2.mat
% Measuring Error		
errfun = @(x1, x2) abs(x1-x2)/abs(x1);		
 		
% initialize x_0		
x0 = randn(n,1);		
 		
% Calling CVX Gurobi		
opts1=[];		
tic;		
[x1,out1] = cvx_Gurobi(c,A,b,opts1,x0);		
t1 = toc;		
 		
 % Calling CVX Mosek		
 % opts2=[];		
 % tic;		
 % [x2,out2] = cvx_Mosek(c,A,b,opts2,x0);		
 % t2 = toc;		
 % 		
 % Calling Gurobi directly		
 % opts3=[];		
 % tic;		
 % [x3,out3] = Gurobi(c,A,b,opts3,x0);		
 % t3 = toc;		
 % 		
 % Calling Mosek directly		
 % opts4=[];		
 % tic;		
 % [x4,out4] = Mosek(c,A,b,opts4,x0);		
 % t4 = toc;		
 		
% 1(b)		
opts5=[];		
tic;		
[x5,out5] = LP_ALM_SG(c,A,b,opts5,x0);		
t5 = toc;		
 		
% 1(c)		
opts6=[];		
tic;		
[x6,out6] = LP_ALM_NCG(c,A,b,opts6,x0);		
 t6 = toc;		
 		
% 2(a)_DRS		
opts7=[];		
tic;		
[x7,out7] = LP_DRS(c,A,b,opts7,x0);		
t7 = toc;		
 		
% 2(a)_ADMM		
opts8=[];		
tic;		
[x8,out8] = LP_ADMM(c,A,b,opts8,x0);		
t8 = toc;		
 		
% 2(c)_SNM		
opts9=[];		
tic;		
[x9,out9] = LP_SNM(c,A,b,opts9,x0);		
t9 = toc;		
 		
%fprintf('  Call CVX Mosek : cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t2, errfun(out1, out2));		
%fprintf('  Call Gurobi : cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t3, errfun(out1, out3));		
%fprintf('  Call Mosek : cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t4, errfun(out1, out4));		
fprintf('  Call LP_ALM_SG : cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t5, errfun(out1, out5));		
fprintf('  Call LP_ALM_SG : constraints: %3.2e\n', norm(A*x5-b)^2);		
fprintf('  Call LP_ALM_NCG : cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t6, errfun(out1, out6));		
fprintf('  Call LP_ALM_NCG : constraints: %3.2e\n', norm(A*x6-b)^2);		
fprintf('  Call DRS : cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t7, errfun(out1, out7));		
fprintf('  Call DRS : constraints: %3.2e\n', norm(A*x7-b)^2);		
fprintf('  Call ADMM : cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t8, errfun(out1, out8));		
fprintf('  Call ADMM : constraints: %3.2e\n', norm(A*x8-b)^2);		
fprintf('  Call SNM : cpu: %5.2f, err to CVX Call Gurobi: %3.2e\n', t9, errfun(out1, out9));		
fprintf('  Call SNM : constraints: %3.2e\n', norm(A*x9-b)^2);