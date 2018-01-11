function [x,out] = special_CVX_Gurobi(Model)
% ��CVX����Gurobi������Թ滮��׼��ʽ
cvx_solver gurobi;
cvx_save_prefs;
A = Model.A;
c = Model.c;
bl = Model.bl;
bu = Model.bu;
tl = Model.tl;
tu = Model.tu;
[m,n] = size(A);

cvx_begin quiet
    variable x(n)
    minimize(c'*x)
    subject to
        bl <= A*x <= bu;
        tl <= x <= tu;
cvx_end

out = cvx_optval;

end

