%% Trying out the power flow surrogate
% We try solving an OPF problem with our brand new surrogate.

%%
clear variables
aaSetupPath

%% Initialize OPF problem
pf_surrogate_spec = PowerFlowSurrogateSpec_Bernstein2017_LP_3();
use_gridlab = false;
opf_problem = GetExampleOPFproblem(pf_surrogate_spec,use_gridlab);

% Select solver
opf_problem.sdpsettings = sdpsettings('solver','sedumi');

%% Solve OPF problem
% The problem is infeasible (see error message at the bottom)
% which suggests that there might a bug in our implementation.
% As we mentioned at the beginning, implementing power flow surrogates is an
% error prone process.
[objective_value,solver_time,diagnostics] = opf_problem.Solve();

