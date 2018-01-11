clear all; clear classes; close all;

src='MPS-presolve-mat-trans';
des='MPS-answers';


fileFolder=fullfile(src);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';

Probname = fileNames;

nlen = length(Probname);
problist = [1:nlen];

for dprob = 1:length(problist)
    pid  = problist(dprob);
    name = Probname{pid};
    fprintf('\n name: %s\n', name);
    load(strcat(src,filesep,name),'A0','b','c','n');
   % cvx_gurobi
    tic;
    [x0,optval_cvx_Gurobi]=cvx_Gurobi(c,A0,b);
    t_cvx_Gurobi = toc;
    optx_cvx_Gurobi=x0(1:n,:)-x0(n+1:2*n,:);
%     % cvx_mosek
%     tic;
%     [x0,optval_cvx_Mosek]=cvx_Mosek(c,A0,b);
%     t_cvx_Mosek = toc;
%     optx_cvx_Mosek=x0(1:n,:)-x0(n+1:2*n,:);
%    % Mosek
%     tic;
%     [x0,optval_Mosek]=Mosek(c,A0,b);
%     t_Mosek = toc;
%     optx_Mosek=x0(1:n,:)-x0(n+1:2*n,:);
   % Gurobi
    tic;
    [x0,optval_Gurobi]=Gurobi(c,A0,b);
    t_Gurobi = toc;
    optx_Gurobi=x0(1:n,:)-x0(n+1:2*n,:);
    save(strcat(des,filesep,name,'_answer.mat'),'optx_cvx_Gurobi','optval_cvx_Gurobi','t_cvx_Gurobi'...
        ,'optx_Gurobi','optval_Gurobi','t_Gurobi');
end

fprintf('\n Done! \n');