function [x,out] = LP_ALM_SG( c,A,b,opts,x0 )
%GM_1B 
[m,n] = size(A);
y = zeros(m,1);
step_size = 1/max(eig(A'*A));
rho = 100;
tol1 = 1e-10;
Grd = ones(m,1);
x = x0;
while norm(Grd) > tol1
    for i=1:5
        if(i>1)
            s=y-y0;
            g=Grd-Grd0;
            step_size=(s'*s)/(s'*g);
            if(step_size>0.001)
                step_size=0.001;
            elseif(step_size<1e-4)
                step_size=1e-4;
            end
        end
        Grd0=Grd;
        Grd = rho*(A'*y-c)+x;
        Grd(Grd<=0) = 0;  
        Grd = A*Grd-b;
        y0=y;
        y = y - step_size * Grd;
    end
    x = x + rho * (A' * y - c);
    x(x <= 0) = 0;
end
out = c'*x;
end

