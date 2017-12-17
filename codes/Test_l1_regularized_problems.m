% function Test_l1_regularized_problems

% min 0.5 ||Ax-b||_2^2 + mu*||x||_1
%load data.mat
% generate data
for i=1:10
n = 1024;
m = 512;

A = randn(m,n);
u = sprandn(n,1,0.1);
b = A*u;

mu = 1e-3;

x0 = rand(n,1);

errfun = @(x1, x2) norm(x1-x2)/(1+norm(x1));

% cvx calling mosek
opts1 = []; %modify options
tic; 
[x1, out1] = l1_cvx_mosek(x0, A, b, mu, opts1);
t1 = toc;
% done.

% % cvx calling gurobi
% opts2 = []; %modify options
% tic; 
% [x2, out2] = l1_cvx_gurobi(x0, A, b, mu, opts2);
% t2 = toc;
% 
% % % call mosek directly
% % opts3 = []; %modify options
% % tic; 
% % [x3, out3] = l1_mosek(x0, A, b, mu, opts3);
% % t3 = toc;
% % 
% % call gurobi directly
% opts4 = []; %modify options
% tic; 
% [x4, out4] = l1_gurobi(x0, A, b, mu, opts4);
% t4 = toc;
% 
% opts5 = []; %modify options
% tic; 
% [x5, out5] = Projection_Gradient_Method(x0, A, b, mu, opts5);
% t5= toc;
% 
% opts6 = []; %modify options
% tic; 
% [x6, out6] = SubGradient_Method(x0, A, b, mu, opts6);
% t6 = toc;
% 
% 
% 
% opts7 = []; %modify options
% tic; 
% [x7, out7] = Gradient_Smooth(x0, A, b, mu, opts7);
% t7 = toc;
% opts8 = []; %modify options
% tic; 
% [x8, out8] = Fast_Gradient_Smooth(x0, A, b, mu, opts8);
% t8 = toc;
% opts9 = []; %modify options
% tic; 
% [x9, out9] = Proximal_Gradient(x0, A, b, mu, opts9);
% t9 = toc;
% opts10 = []; %modify options
% tic; 
% [x10, out10] = Fast_Proximal_Gradient(x0, A, b, mu, opts10);
% t10 = toc;
% 
% opts11 = []; %modify options
% tic; 
% [x11, out11] = AugmentedLagrangian(x0, A, b, mu, opts11);
% t11 = toc;
% 
% opts12 = []; %modify options
% tic; 
% [x12, out12] = ADMM_Dual(x0, A, b, mu, opts12);
% t12 = toc;
% 
% 
% opts13 = []; %modify options
% tic; 
% [x13, out13] = ADMMP(x0, A, b, mu, opts13);
% t13 = toc;
% 
% opts14 = []; %modify options
% tic; 
% [x14, out14] = LADMMP(x0, A, b, mu, opts14);
% t14 = toc;
% 
% opts15 = []; %modify options
% tic; 
% [x15, out15] = PADMMP(x0, A, b, mu, opts15);
% t15 = toc;
% 
opts16 = []; %modify options
tic; 
[x16, out16] = Adagrad(x0, A, b, mu, opts16);
t16 = toc;

opts17 = []; %modify options
tic; 
[x17, out17] = RMSProp(x0, A, b, mu, opts17);
t17 = toc;

opts18 = []; %modify options
tic; 
[x18, out18] = SGDM(x0, A, b, mu, opts18);
t18 = toc;

opts19 = []; %modify options
tic; 
[x19, out19] = SGDNM(x0, A, b, mu, opts19);
t19 = toc;


opts20 = []; %modify options
tic; 
[x20, out20] = RMSPropNM(x0, A, b, mu, opts20);
t20 = toc;

opts21 = []; %modify options
tic; 
[x21, out21] = Adam(x0, A, b, mu, opts21);
t21 = toc;



% % %print comparison results with cvx-call-mosek
% fprintf('cvx-call-gurobi: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t2, errfun(x1, x2));
% %fprintf('     call-mosek: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t3, errfun(x1, x3));
% fprintf('    call-gurobi: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t4, errfun(x1, x4));
% fprintf('     ProjectionGradient: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t7, errfun(x1, x5));
% fprintf('     SubGradient: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t8, errfun(x1, x6));
% fprintf('     GradientSmooth: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t7, errfun(x1, x7));
% fprintf('     FastGradientSmooth: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t8, errfun(x1, x8));
% fprintf('     ProximalGradient: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t9, errfun(x1, x9));
% fprintf('     FastProximalGradient: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t10, errfun(x1, x10));
% fprintf('     AL: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t11, errfun(x1, x11));
% fprintf('     ADMM_Dual: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t12, errfun(x1, x12));
% fprintf('     ADMMP: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t13, errfun(x1, x13));
% fprintf('     LADMMP: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t14, errfun(x1, x14));
% fprintf('     PADMMP: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t15, errfun(x1, x15));
fprintf('     Adagrad: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t16, errfun(x1, x16));
fprintf('     RMSProp: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t17, errfun(x1, x17));
fprintf('     SGDM: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t18, errfun(x1, x18));
fprintf('     SGDNM: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t19, errfun(x1, x19));
fprintf('     RMSPropNM: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t20, errfun(x1, x20));
fprintf('     Adam: cpu: %5.2f, err-to-cvx-mosek: %3.2e\n', t21, errfun(x1, x21));
end