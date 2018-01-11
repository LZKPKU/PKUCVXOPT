% function test_LP_table


% clc;
clear all; clear classes; close all;

seed = randi(1e8);
seed = 97006855;
fprintf('seed = %d;\n', seed);
% rand('state',seed); randn('state',seed^2);
ss = RandStream('mt19937ar','Seed',seed);
RandStream.setGlobalStream(ss);

presolve = 1;


srcmat = '/Users/wenzw/work/ADM-BCD/code/MPS-presolve-mat';



Probname = { '25fv47',  '80bau3b',  'adlittle',  'afiro',  'agg',  'agg2',  ... % 1 -- 6
    'agg3',  'bandm',  'beaconfd',  'blend',  'bnl1',  'bnl2',  ... % 7 -- 12
    'boeing1',  'boeing2',  'bore3d',  'brandy',  'capri',  'cre-a',  ... % 13 -- 18
    'cre-b',  'cre-c',  'cre-d',  'cycle',  'czprob',  'd2q06c',  ... % 19 -- 24
    'd6cube',  'degen2',  'degen3',  'dfl001',  'e226',  'etamacro',  ... % 25 -- 30
    'fffff800',  'finnis',  'fit1d',  'fit1p',  'fit2d',  'fit2p',  ... % 31 -- 36
    'forplan',  'ganges',  'gfrd-pnc',  'greenbea',  'greenbeb',  'grow15',  ... % 37 -- 42
    'grow22',  'grow7',  'israel',  'kb2',  'ken-07',  'ken-11',  ... % 43 -- 48
    'ken-13',  'ken-18',  'lotfi',  'maros',  'maros-r7',  'modszk1',  ... % 49 -- 54
    'nesm',  'osa-07',  'osa-14',  'osa-30',  'osa-60',  'out.txt',  ... % 55 -- 60
    'pds-02',  'pds-06',  'pds-10',  'pds-20',  'perold',  'pilot',  ... % 61 -- 66
    'pilot4',  'pilot87',  'pilot.ja',  'pilotnov',  'pilot.we',  'qap08',  ... % 67 -- 72
    'qap12',  'qap15',  'recipe',  'sc105',  'sc205',  'sc50a',  ... % 73 -- 78
    'sc50b',  'scagr25',  'scagr7',  'scfxm1',  'scfxm2',  'scfxm3',  ... % 79 -- 84
    'scorpion',  'scrs8',  'scsd1',  'scsd6',  'scsd8',  'sctap1',  ... % 85 -- 90
    'sctap2',  'sctap3',  'seba',  'share1b',  'share2b',  'shell',  ... % 91 -- 96
    'ship04l',  'ship04s',  'ship08l',  'ship08s',  'ship12l',  'ship12s',  ... % 97 -- 102
    'sierra',  'stair',  'standata',  'standgub',  'standmps',  'stocfor1',  ... % 103 -- 108
    'stocfor2',  'tuff',  'vtp_base',  'wood1p',  'woodw'};  ... % 109 -- 113
    

tol = 1e-5;
% tol = 1e-10;

nlen = length(Probname);
problist = [1:nlen];
problist = [4];


for dprob = 1:length(problist);
    pid  = problist(dprob);
    name = Probname{pid};
    if presolve; name = strcat(name,'pre'); end
    fprintf('\n name: %s\n', name);
    load(strcat(srcmat,filesep,name,'.mat'),'Model');
    
    clear cplex
    %     try
    tic;
    cplex = Cplex();
    %cplex.Param.CPX_PARAM_SCRIND = 0;
    %cplex.readModel(strcat(src,filesep,name,'.mps'));
    cplex.Model = Model;
    
    %Model = cplex.Model;
    %save(strcat(srcmat,filesep,name,'.mat'),'Model');
    cplex.solve();
    t1 = toc;
    
    
    [m,n] = size(cplex.Model.A);
    xs = cplex.Solution.x;
    y  = cplex.Solution.dual;
    pobj = xs'*Model.obj;
    
    fprintf('%2d & %10s & (%5d, %5d) && %3.2e & %5.2f \n', ...
        pid, name, m, n, pobj, t1);
    
    %     catch exception
    %         fprintf(' exception \n');
    %         continue
    %     end
    
    if strcmp(Model.sense, 'minimize') == 0
        Model.sense
        Model.obj = -Model.obj;
    end
    
    
    switchTol = 1e-2;
    opts.tol  = 1e-8;
    
    % LM to DRS
    opts.doLM = 0;
    opts.record = 0;
    % opts.sigma = 1.5;
    opts.tau = 1e-1;
    %opts.itPrintFP = 10;
    opts.maxit = 1e2;
    opts.maxits = 1e4;
    opts.switchTol = switchTol;
    
    %opts.maxItStag = 50;
    tic; [x,out] = ssmLMLP(Model, opts);
    t1 = toc;
    pobj = x'*Model.obj;
    err = norm(x-xs)/norm(xs);
    fprintf('DRS:   (%5d, %5d) && %3.2e & %5.2f & %2.1e & (%2d, %3d)\n', ...
        m, n, pobj, t1, err, out.iter, out.iters);
    
    % LM to DRS
    opts.doLM = 1;
    opts.record = 1;
    opts.maxit = 1e2;
    opts.maxits = 1e2;
    
    %opts.maxItStag = 50;
    opts.switchTol = switchTol;
    tic; [x,out] = ssmLMLP(Model, opts);
    t1 = toc;
    pobj = x'*Model.obj;
    err = norm(x-xs)/norm(xs);
    fprintf('DRSLM: (%5d, %5d) && %3.2e & %5.2f & %2.1e & (%2d, %3d)\n', ...
        m, n, pobj, t1, err, out.iter, out.iters);
    % [xs x]
    
    continue;
    
    
    
    %     pinf = norm(cplex.Model.A*x1-b)/(1+norm(b));
    %     dinf = norm(min(cplex.Model.obj+cplex.Model.A'*y,0))/(1+norm(c));
    %     pobj = c'*x1; dobj = -(b'*y);
    %     gap = abs(pobj-dobj)/(1+abs(pobj)+abs(dobj));
    %
    %     fprintf('%2d & %10s & (%5d, %5d) && %3.2e & %3.2e & %3.e & %5.2f \n', ...
    %         pid, name, m, n, pinf, dinf, gap, t1);
    
    
    % % adp_beta = 0; maxit = 1000; rho = 1.2; beta = 1e-2;
    %dotA = dot(A,A);
    %beta = 1/(max(dotA));
    %beta = norm(b)/max(dot(A,A));
    % beta = 1;
    % beta = 400/norm(b,1);
    % % beta = 1;
    % beta = 1e-2;
    
    
    
end
