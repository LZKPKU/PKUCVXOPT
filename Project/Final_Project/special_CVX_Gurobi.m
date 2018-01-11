function [x,out] = special_CVX_Gurobi(Model)
% 用CVX调用Gurobi求解线性规划标准形式
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

