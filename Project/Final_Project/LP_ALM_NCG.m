function [x,out] = LP_ALM_NCG( c,A,b,opts,x0 )
%GM_1B 
%1st-order method of ALM
[m,n] = size(A);
y = zeros(m,1);
rho = 1.618;
tol1 = 1e-10;
Grd = ones(n,1);
x = x0;
tau1 = 0.5;
tau2 = 0.5;
mu = 0.25;
delta = 0.5;

while norm(Grd) > tol1
    %update y
    for i = 1:4
        Grd = rho*(A'*y-c)+x;
        Grd(Grd<=0) = 0;
        e = sign(Grd);
        E = diag(e);
        A0 = A*E;
        Grd = A*Grd-b; %subgradient
        epsl = tau1*min(tau2,norm(Grd));

        %(A0*A0'+epsilon*I)d = Grd
        d = (A0*A0'+epsl*eye(m))\Grd; %descent direction
        
%         % CG
%         ACG = A0*A0'+epsl*eye(m);
%         bCG = Grd;
%         etaCG = 1e-2;
%         Max_itrCG = 100;
%         d = 0.1*ones(m,1);
%         r = bCG-ACG*d;
%         lo = r'*r;
%         kCG=0;
%         % stop condition
%         while sqrt(lo) > etaCG * norm(bCG) && kCG < Max_itrCG
%             kCG = kCG + 1;
%             if kCG == 1
%                 p = r;
%             else
%                 beta = lo/lol;
%                 p = r+beta*p;
%             end
%             temp = ACG*p;
%             alpha = lo/(p'*temp);
%             d = d+alpha*p;
%             r = r - alpha*temp;
%             lol = lo;
%             lo = r'*r;
%         end
%         %d
        
        %line search       
        j=0;
        while L(y-delta^j*d,x,rho,A,b,c)>L(y,x,rho,A,b,c)+mu*delta^j*d'*Grd && j<=10
            j = j + 1;
        end
        y = y-delta^j*d;
    end
    %update x
    x = x + rho * (A' * y - c);
    x(x <= 0) = 0;
end
out = c'*x;
end

function[out]=L(y,x,rho,A,b,c)
out = -b'*y;
Grd = rho*(A'*y-c)+x;
Grd(Grd<=0) = 0; 
out = out  + (norm(Grd)^2 - norm(x)^2)/(2*rho);
end