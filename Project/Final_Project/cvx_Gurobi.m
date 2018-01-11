function [x,out] = cvx_Gurobi(c,A,b,opts,x0);
% ��CVX����Gurobi������Թ滮��׼��ʽ
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

