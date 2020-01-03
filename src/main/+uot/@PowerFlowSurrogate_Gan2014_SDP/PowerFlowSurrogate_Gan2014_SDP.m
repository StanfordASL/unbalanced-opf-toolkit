classdef PowerFlowSurrogate_Gan2014_SDP < uot.PowerFlowSurrogate_Gan2014
    % Implements the convex (SDP) power flow surrogate presented in :cite:`Gan2014`.
    %
    % Synopsis::
    %
    %   obj = uot.PowerFlowSurrogate_Gan2014_SDP(spec,opf_problem)
    %
    % Description:
    %   This power flow surrogate is a relaxation of the power flow equations for a 
    %   radial power distribution network. The relaxation consists in removing a
    %   non-convex rank-constraint.
    %
    %   Since the surrogate is a relaxation, if the optimal solution happens to 
    %   fulfill the rank constraint, then the solution is optimal for the original problem
    %   as well. If this is not the case, ComputeVoltageEstimate will throw a warning: 
    %   "Max M eigenvalue ratio = %d is too high, solution is inaccurate.".
    %
    % Arguments:
    %   spec (|uot.PowerFlowSurrogateSpec_Gan2014_SDP|): Object specification
    %   opf_problem (|uot.OPFproblem|): OPF problem where the power flow surrogate will be used
    %
    % Example::
    %
    %   % This class should be instantiated via its specification
    %   spec = uot.PowerFlowSurrogateSpec_Gan2014_SDP();
    %   pf_surrogate = spec.Create(opf_problem);
    %
    % See Also:
    %   |uot.PowerFlowSurrogateSpec_Gan2014_SDP|

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = PowerFlowSurrogate_Gan2014_SDP(spec,opf_problem)
            validateattributes(spec,{'uot.PowerFlowSurrogateSpec_Gan2014_SDP'},{'scalar'},mfilename,'spec',1);
            decision_variables = uot.PowerFlowSurrogate_Gan2014_SDP.DefineDecisionVariables(opf_problem);

            obj@uot.PowerFlowSurrogate_Gan2014(spec,opf_problem,decision_variables)
        end

        I_link_from_array = ComputeLinkCurrentEstimate(obj)

        % Implemented abstract methods from uot.ConstraintProvider
        constraint_array = GetConstraintArray(obj)
    end

    properties (Access = public)
        % We measure the degree of solution exactness by the ratio of the 2
        % largest eigenvalues in the M matrices. If the largest ratio is greater
        % than M_eigenvalue_ratio_tol, a warning is issued.
        M_eigenvalue_ratio_tol(1,1) double {mustBePositive,mustBeLessThan(M_eigenvalue_ratio_tol,1)} = 1e-4
    end

    % ComputeVoltageEstimate is abstract so we cannot add output for
    % M_eigenvalue_ratio_max. Hence, we set it here so that it can be
    % latter recovered
    properties(SetAccess = protected, GetAccess = public)
        M_eigenvalue_ratio_max
    end

    % Implemented abstract methods from uot.AbstractPowerFlowSurrogate
    methods (Access = {?uot.AbstractPowerFlowSurrogate,?uot.OPFproblem})
        [U_array,T_array] = ComputeVoltageEstimate(obj)
        [U_array,T_array,p_pcc_array,q_pcc_array] = AssignBaseCaseSolution(obj)
    end

    methods (Static)
        function [U_array,T_array, p_pcc_array, q_pcc_array,opf_problem] = SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array)
            pf_surrogate_spec = uot.PowerFlowSurrogateSpec_Gan2014_SDP;
            [U_array,T_array, p_pcc_array, q_pcc_array,opf_problem] = uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper(pf_surrogate_spec,load_case,u_pcc_array,t_pcc_array);
        end
    end

    methods (Static, Access = protected)
       decision_variables = DefineDecisionVariables(opf_problem)
    end

    methods (Access = private)
        m_eigenvalue_ratio = ComputeEigenValueRatio(obj,link,i_time_step)
        M_link = GetMlink(obj,link,i_time_step)
        [V_array,I_link_array] = RecoverVI(obj)
    end
end