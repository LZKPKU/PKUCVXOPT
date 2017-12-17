function [ x3,out3 ] = l1_mosek(x0,A,b,mu,opts3)
%ֱ�ӵ���Mosek���
[m,n] = size(A);
%���������
q = [0.5*A'*A,zeros(n,n);zeros(n,n),zeros(n,n)];
%���κ��һ�������
c = [zeros(n,1);mu*ones(n,1)];
%Լ��ϵ������
a = [eye(n),eye(n);-eye(n),eye(n)];
u = A\b;
%Լ��ֵ����
blc = [-u;u];
results = mskqpopt(q,c,a,blc,[],[],[],[],'minimize');
% ����ֵ
x3 = results.sol.itr.xx(1:n)+u;
out3 = results.sol.itr.pobjval;
end