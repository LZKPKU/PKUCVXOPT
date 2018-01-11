function [ x, out ] = OT_CVX_GRB_Dual( C,mu,nu )
%Optimal Transport problem
%Using SDP form of the dual problem
%minimize <U,A>+<V,B>
%subject to AE+EB<=C
cvx_solver gurobi;
cvx_save_prefs;

N = length(C);
E = ones(N,N);

cvx_begin
    variables a(N) b(N)
    dual variable X
    maximize (mu'*a+nu'*b)
    subject to
        X : diag(a)*E+E*diag(b) <= C
cvx_end

x = reshape(X',[],1);
out = cvx_optval;
end

