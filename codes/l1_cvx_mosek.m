function [x1, out1] = l1_cvx_mosek(x0, A, b, mu, opts1)
% Calling mosek in CVX.
cvx_solver mosek;
cvx_save_prefs;

[m,n] = size(A);

cvx_begin quiet
    variable x(n)
    minimize(0.5*square_pos(norm(A*x-b,2))+mu*norm(x,1))
cvx_end
x1 = x;
out1 = cvx_optval;
end

