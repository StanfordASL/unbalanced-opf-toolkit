%% Debugging the power flow surrogate
% We use :meth:`PowerFlowSurrogate_Bernstein2017_LP_3.AssignBaseCaseSolution` to debug the power flow surrogate.

%%
clear variables
aaSetupPath

%% Initialize OPF problem
pf_surrogate_spec = PowerFlowSurrogateSpec_Bernstein2017_LP_3();
use_gridlab = false;
opf_problem = GetExampleOPFproblem(pf_surrogate_spec,use_gridlab);

% Select solver
opf_problem.sdpsettings = sdpsettings('solver','sedumi');

%% Try to solve
% Problem is infeasible as we expected (see error message at the bottom)
[objective_value,solver_time,diagnostics] = opf_problem.Solve();

%% Assign the base case solution
[U_array,T_array,p_pcc_array,q_pcc_array] = opf_problem.AssignBaseCaseSolution();

%% Check constraint satisfaction
% The base case solution should be feasible. We can verify this
% by seeing if the constraints are fulfilled using YALMIP's check
% method (https://yalmip.github.io/command/check/).
% From this page, we see that "a solution is feasible
% if all residuals related to inequalities are non-negative."
constraint_array = opf_problem.GetConstraintArray();
check(constraint_array)

%% Examine U_array
% We see that "U_box_constraint lower bound" is clearly infeasible.
% Clearly, the constraint is violated since we set a minimal magnitude of
% 0.95 in GetExampleOPFproblem.
U_array

%% Examine U_array_ref
% We now examine what U_array is if we solve power flow for the base case
% exactly.
% We see that all voltages are above 0.95. In fact, some are even above 1.05
% which is the maximal allowed voltage magnitude in our OPF problem.
% This suggests that the issue is that the power flow surrogate is not
% very accurate in this case.
[U_array_ref,T_array_ref,p_pcc_array_ref,q_pcc_array_ref] = opf_problem.SolvePFbaseCase();
U_array_ref

%% Change linearization point
% One way of increasing the accuracy is by bringing the linearization point
% closer to the operating conditions. Hence, we now linearize at the load in the first time step of the base case.
opf_problem.pf_surrogate.linearization_point = uot.enum.CommonLinearizationPoints.PFbaseCaseFirstTimeStep;

%% Assign the new base case solution
% We assign the base case solution again and examine U_array_2
% It now matches U_array_ref exactly. This is not surprising since we are linearizing
% at precisely that operating point.
[U_array_2,T_array_2,p_pcc_array_2,q_pcc_array_2] = opf_problem.AssignBaseCaseSolution();
U_array_2

%% Check constraint satisfaction
% We now see that U_box_constraint lower bound is feasible (i.e, has non-negative
% residual). We also notice that U_box_constraint upper bound is now infeasible.
% However, this is not a problem since we know that the exact solution has a
% few voltages above the upper limit of 1.05.
constraint_array = opf_problem.GetConstraintArray();
check(constraint_array)


%% Try to solve again
% It works!
[objective_value,solver_time,diagnostics] = opf_problem.Solve();























