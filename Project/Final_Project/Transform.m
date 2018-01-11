clear all; clear classes; close all;

src='MPS-presolve-mat';
des='MPS-presolve-mat-trans';
%  Probname = { '25fv47'};

fileFolder=fullfile('MPS-presolve-mat');
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';

Probname = fileNames;

nlen = length(Probname);
problist = [1:nlen];

for dprob = 1:length(problist)
    pid  = problist(dprob);
    name = Probname{pid};
    fprintf('\n name: %s\n', name);
    load(strcat(src,filesep,name),'Model');
    [m,n]=size(Model.A);
    A0=sparse(2*m+2*n,4*n+2*m);
    A0(1:m,1:n)=Model.A;
    A0(1:m,n+1:2*n)=-Model.A;
    A0(m+1:2*m,1:n)=Model.A;
    A0(m+1:2*m,n+1:2*n)=-Model.A;
    I1=sparse(1:m,1:m,1);
    I2=sparse(1:n,1:n,1);
    A0(2*m+1:2*m+n,1:n)=I2;
    A0(2*m+1:2*m+n,n+1:2*n)=-I2;
    A0(2*m+n+1:2*m+2*n,1:n)=I2;
    A0(2*m+n+1:2*m+2*n,n+1:2*n)=-I2;
    A0(1:m,2*n+1:2*n+m)=-I1;
    A0(m+1:2*m,2*n+m+1:2*n+2*m)=I1;
    A0(2*m+1:2*m+n,2*n+2*m+1:3*n+2*m)=-I2;
    A0(2*m+n+1:2*m+2*n,3*n+2*m+1:4*n+2*m)=I2;
    b=[Model.lhs;Model.rhs;Model.lb;Model.ub];
    c=[Model.obj;-Model.obj;zeros(m,1);zeros(m,1);zeros(n,1);zeros(n,1)];
    cnt=zeros(n,1);
    flag=zeros(2*m+2*n,1);
    for i=1:m
        if(b(i)==inf||b(i)==-inf)
            flag(i)=1;
        end
        if(b(m+i)==inf||b(m+i)==-inf)
            flag(m+i)=1;
        end
    end
    for i=1:n
        if(b(2*m+i)==inf||b(2*m+i)==-inf)
            flag(2*m+i)=1;
        end
        if(b(2*m+n+i)==inf||b(2*m+n+i)==-inf)
            flag(2*m+n+i)=1;
        end
    end
    A0(flag==1,:)=[];
    b(flag==1,:)=[];
    save(strcat(des,filesep,name,'_trans.mat'),'A0','b','c','n');
   % bash(A0,b,c,1);
end