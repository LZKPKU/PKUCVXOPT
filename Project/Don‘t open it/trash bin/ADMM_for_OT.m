function [optx,optval] = ADMM_for_OT(c,x0,u,v)
[m,n]=size(x0);
x=reshape(x0',[],1);
A=sparse([],[],[],n+m,n*m,0);
c=reshape(c',[],1);
b=[u;v];
z=x;
lambda=zeros(m+n,1);
mu=zeros(m*n,1);
rho=1.618;
for i=1:m
    A(i,(1+n*(i-1)):n+n*(i-1))=1;
end
for i=1:n
    for j=1:m
        A(m+i,i+n*(j-1))=1;
    end
end
L=sparse(chol(A'*A+sparse(1:m*n,1:m*n,1)));
U=sparse(L');
for k=1:200
    tmp=L\(U\(A'*b+z-(c+A'*lambda-+mu)/rho));
    x=zeros(m*n,1);
    x(tmp>0)=tmp(tmp>0);
    tmp=x+mu/rho;
    z=zeros(m*n,1);
    z(tmp>0)=tmp(tmp>0);
    lambda=lambda+rho*(A*x-b);
    mu=mu+rho*(z-x);
end
optval=c'*x;
optx=zeros(m,n);
for i=1:m
    optx(i,:)=x(1+(i-1)*n:n+(i-1)*n);
end
end