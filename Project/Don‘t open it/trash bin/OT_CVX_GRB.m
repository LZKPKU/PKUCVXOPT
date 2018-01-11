function [x,out] = OT_CVX_GRB(C,mu,nu)
% CVX解优化运输问题
cvx_solver gurobi;
cvx_save_prefs;

n = length(C);
c = reshape(C',[],1);
A=zeros(n+n,n*n);
b = [mu;nu];


for i=1:n
    A(i,(1+n*(i-1)):n+n*(i-1))=1;
end
for i=1:n
    for j=1:n
        A(n+i,i+n*(j-1))=1;
    end
end

cvx_begin
    variable x(n*n)
    dual variables y z
    minimize(c'*x)
    subject to
        y:A*x == b;
        z:x >= 0;
cvx_end

x = x;
out = cvx_optval;

end

