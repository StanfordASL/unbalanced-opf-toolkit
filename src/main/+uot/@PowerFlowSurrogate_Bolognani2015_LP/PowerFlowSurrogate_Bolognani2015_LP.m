classdef PowerFlowSurrogate_Bolognani2015_LP < uot.AbstractPowerFlowSurrogate
    % Implements the power flow surrogate presented in :cite:`Bolognani2015`
    %
    % Synopsis::
    %
    %   obj = uot.PowerFlowSurrogate_Bolognani2015_LP(spec,opf_problem)
    %
    % Description:
    %   This power flow surrogate uses an implicit linear formulation to 
    %   approximate the power flow equation.  The formulation is based on the 
    %   linearization of the power flow manifold.
    %
    %   This implementation does not keep track of phase since it is not
    %   necessary for implementing the required constraints.
    %
    % Arguments:
    %   spec (|uot.PowerFlowSurrogateSpec_Bolognani2015_LP|): Object specification
    %   opf_problem (|uot.OPFproblem|): OPF problem where the power flow surrogate will be used
    %
    % Example::
    %
    %   % This class should be instantiated via its specification
    %   spec = uot.PowerFlowSurrogateSpec_Bolognani2015_LP();
    %   pf_surrogate = spec.Create(opf_problem);
    %
    % See Also:
    %   |uot.PowerFlowSurrogateSpec_Bolognani2015_LP|
    % 
    % Todo:
    %
    %   - Check if sparse_precision is necessary. Maybe we can get rid of it.
    

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = PowerFlowSurrogate_Bolognani2015_LP(spec,opf_problem)
            validateattributes(spec,{'uot.PowerFlowSurrogateSpec_Bolognani2015_LP'},{'scalar'},mfilename,'spec',1);
            decision_variables = uot.PowerFlowSurrogate_Bolognani2015_LP.DefineDecisionVariables(opf_problem);
            obj@uot.AbstractPowerFlowSurrogate(spec,opf_problem,decision_variables)
        end

        [U_array,T_array] = ComputeVoltageMangitudeEstimate(obj)

        % Implemented abstract methods from uot.ConstraintProvider
        constraint_array = GetConstraintArray(obj)
    end

    properties
        % In some cases scaling improves solver performance. However, sometimes it leads to weird behavior due
        % to numerical errors. For example, causing the test "SolutionFulfillsLinearPowerFlowAndConstraints" to
        % fail.
        scale_flag(1,1) logical = false
        sparse_precision
        linearization_point(1,1) uot.enum.CommonLinearizationPoints = uot.enum.CommonLinearizationPoints.PFbaseCaseFirstTimeStep
    end

    % Implemented abstract methods from uot.AbstractPowerFlowSurrogate
    methods (Access = {?uot.AbstractPowerFlowSurrogate,?uot.OPFproblem})
        [U_array,T_array] = ComputeVoltageEstimate(obj)
        [U_array,T_array,p_pcc_array,q_pcc_array] = AssignBaseCaseSolution(obj,U,T)
    end

    methods (Static)
        function [U_array,T_array, p_pcc_array, q_pcc_array,opf_problem] = SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array)
            pf_surrogate_spec = uot.PowerFlowSurrogateSpec_Bolognani2015_LP;
            [U_array,T_array, p_pcc_array, q_pcc_array,opf_problem] = uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper(pf_surrogate_spec,load_case,u_pcc_array,t_pcc_array);
        end

        [U_array,T_array, p_pcc_array, q_pcc_array] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,varargin)
    end

    methods (Access = private)
        state_vector = GetStateVectorAtPowerFlowBaseCase(obj,time_step)
        state_vector_ast = GetStateVectorForLinearization(obj)
    end

    methods (Static, Access = private)
        decision_variables = DefineDecisionVariables(opf_problem)
        A = GetAmatrix(network,state_vector_ast)
        [C_ast,d_ast] = GetBusModel(network,state_vector_ast,P_inj_array_stack,Q_inj_array_stack,u_pcc_array,t_pcc_array)
        state_vector = GetStateVectorAtVoltage(network,U,T)
        state_vector_array = MergeState(U_array_stack,T_array_stack,P_inj_array_stack,Q_inj_array_stack)
        [U_stack_array, T_stack_array, P_stack_array, Q_stack_array] = SplitState(state_vector_array)
    end
end