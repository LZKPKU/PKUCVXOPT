% Generate Random Data		
n = 100;		
m = 20;		
A = rand(m,n);		
xs = full(abs(sprandn(n,1,m/n)));		
b = A*xs;		
y = randn(m,1);		
s = rand(n,1).*(xs==0);		
c = A'*y + s;		
 		