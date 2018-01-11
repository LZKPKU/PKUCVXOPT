脚本和函数：

LP_ALM_NCG.m 1(c)

LP_ALM_SG.m  1(b)

LP_ADMM.m 2(a)

LP_DRS.m 2(a)

LP_SNM.m  2(c)

cvx_Gurobi.m cvx_Mosek.m Gurobi.m Mosek.m  给作业要求算法提供真解的函数

CG.m 共轭梯度法函数

bash.m  用随机数据测试作业要求算法的脚本

random_data.m  生成随机标准格式数据的脚本



trans_ADMM.m  将NetLib格式数据转换为标准格式数据再求解的ADMM算法的函数

special_ADMM.m  直接解NetLib所给数据格式的ADMM算法的函数

special_CVX_Gurobi.m  为trans&sp ADMM提供真解的函数

NetLib_bash.m  测试trans&sp ADMM的脚本，生成随机NetLib格式的数据



Transform.m  将NetLib数据转换为标准格式的脚本

NetLib_solver.m  用求解工具求解转换后的NetLib数据的脚本

Testlib_bash.m  用转换后的NetLib数据来测试所有作业要求算法的脚本



数据文件：

test.mat test2.mat test3.mat  测试作业要求算法的三个随机数据集

RES_test_(1,2,3).mat  对应的三个解

Test_on_afiropre.mat  Test_on_sc50apre.mat Test_on_scsd1pre.mat  在三个Netlib数据集上测试作业要求算法的结果，其中最后一个只对DRS做了测试

random_NetLib_1.mat  由NetLib_bash.m生成的随机NetLib数据格式的数据，用以测试trans&sp ADMM

Test_on_trans&sp_ADMM.mat  对应的结果