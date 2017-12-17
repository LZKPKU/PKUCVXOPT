function [x, out] = AugmentedLagrangian(x0, A, b, mu, opts)
[m,n] = size(A);

mu_ori = mu;
mu = 1e5*mu;

z = zeros(m,1);
x = x0;
Maxitr = 7;
rho = 1.618;
beta = 0.5;
alpha = 0.1;

while mu>=mu_ori
    for i = 1:Maxitr
        for j=1:3
            t = rho*A'*z-x;
            grid = z+b+A*(sign(t).*max(abs(t)-rho*mu,0));
            % Newton Method
            % only these rows are nonzeros
            A0 = A(:,abs(t)>rho*mu);
            Hessian = eye(m)+rho*A0*A0';
            y = Hessian\grid;
            
            stepsize=1;
            tmp = sign(A'*z-x/rho).*max(abs(A'*z-x/rho)-mu,0);
            obj = 0.5*z'*z+b'*z+0.5*rho*tmp'*tmp;
            tmpz = z-stepsize*y;
            ttmp = sign(A'*tmpz-x/rho).*max(abs(A'*tmpz-x/rho)-mu,0);
            obj1 = 0.5*tmpz'*tmpz+b'*tmpz+0.5*rho*ttmp'*ttmp;
            while obj1>obj-stepsize*y'*grid*alpha
                stepsize = beta*stepsize;
                tmpz = z-stepsize*y;
                ttmp = sign(A'*tmpz-x/rho).*max(abs(A'*tmpz-x/rho)-mu,0);
                obj1 = 0.5*tmpz'*tmpz+b'*tmpz+0.5*rho*ttmp'*ttmp;
            end
            z = tmpz;
        end
         x = sign(x-rho*A'*z).*max(abs(x-rho*A'*z)-rho*mu,0);
    end
    mu = mu/10;
end
out = 0.5*norm(A*x-b)^2+mu_ori*norm(x,1);
end
