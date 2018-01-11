function [x,out] = cvx_Gurobi(c,A,b,opts,x0);
% 用CVX调用Gurobi求解线性规划标准形式
cvx_solver gurobi;
cvx_save_prefs;

[n,m] = size(c);

cvx_begin quiet
    variable x(n)
    dual variables y z
    minimize(c'*x)
    subject to
        y:A*x == b;
        z:x >= 0;
cvx_end

x = x;
out = cvx_optval;

end

