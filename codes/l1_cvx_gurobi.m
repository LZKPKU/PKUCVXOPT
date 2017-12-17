function [x2, out2] = l1_cvx_gurobi(x0, A, b, mu, opts2)
% Calling Gurobi in CVX
cvx_solver gurobi;
cvx_save_prefs;

[m,n] = size(A);

cvx_begin quiet
    variable x(n)
    minimize(0.5*square_pos(norm(A*x-b,2))+mu*norm(x,1))
cvx_end
x2 = x;
out2 = cvx_optval;
end


