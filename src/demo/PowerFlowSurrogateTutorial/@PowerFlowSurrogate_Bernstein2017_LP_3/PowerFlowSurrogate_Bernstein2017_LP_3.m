classdef PowerFlowSurrogate_Bernstein2017_LP_3 < uot.AbstractPowerFlowSurrogate
    % Implements the power flow surrogate presented in :cite:`Bernstein2017`
    %
    % Synopsis::
    %
    %   obj = uot.PowerFlowSurrogate_Bernstein2017_LP_3(spec,opf_problem)
    %
    % Description:
    %   This class implements the Bernstein2017 power flow surrogate presented in
    %   :cite:`Bernstein2017`. It uses
    %   an explicit linear formulation to approximate the power flow equation.
    %   The formulation is based on the fixed-point solution to the power flow
    %   equation.
    %
    %   This implementation does not keep track of phase since it is not
    %   necessary for implementing the required constraints.
    %
    % Arguments:
    %   spec (|PowerFlowSurrogateSpec_Bernstein2017_LP_3|): Object specification
    %   opf_problem (|uot.OPFproblem|): OPF problem where the power flow surrogate will be used
    %
    % Note:
    %   The paper considers the posibility of delta-connected loads. However, we
    %   do not use them here since |uot.OPFproblem| does not support them.
    %
    % Note:
    %   We add the suffix ``_3`` to distinguish this implementation from the others
    %   that were developed in the course of the tutorial.
    %
    %
    % Example::
    %
    %   % This class is should be instantiated via its specification
    %   spec = PowerFlowSurrogateSpec_Bernstein2017_LP_3();
    %   pf_surrogate = spec.Create(opf_problem);
    %
    % See Also:
    %   |PowerFlowSurrogateSpec_Bernstein2017_LP_3|

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = PowerFlowSurrogate_Bernstein2017_LP_3(spec,opf_problem)
            validateattributes(spec,{'PowerFlowSurrogateSpec_Bernstein2017_LP_3'},{'scalar'},mfilename,'spec',1);

            decision_variables = PowerFlowSurrogate_Bernstein2017_LP_3.DefineDecisionVariables(opf_problem);
            obj@uot.AbstractPowerFlowSurrogate(spec,opf_problem,decision_variables)
        end
        [U_ast,T_ast] = GetLinearizationVoltage(obj)
        constraint_array = GetConstraintArray(obj) % Abstract method from uot.AbstractPowerFlowSurrogate
    end

    methods (Static)
        [U_array,T_array,p_pcc_array,q_pcc_array,opf_problem] = SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array) % Abstract method from uot.AbstractPowerFlowSurrogate class
        [U_array,T_array, p_pcc_array, q_pcc_array,extra_data] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,varargin)
    end

    properties
        linearization_point(1,1) uot.enum.CommonLinearizationPoints = uot.enum.CommonLinearizationPoints.FlatVoltage % Linearization point (|uot.enum.CommonLinearizationPoints|)
    end

    % Protected
    methods (Access = {?uot.AbstractPowerFlowSurrogate,?uot.OPFproblem})
        [U_array,T_array,p_pcc_array,q_pcc_array] = AssignBaseCaseSolution(obj) % Abstract method from uot.AbstractPowerFlowSurrogate
        [U_array,T_array] = ComputeVoltageEstimate(obj) % Abstract method from uot.AbstractPowerFlowSurrogate
    end

    % Private
    methods (Static, Access = private)
        M_y = ComputeMyMatrix(network,V_ast_nopcc_stack)
        U_array_eq9 = ComputeVoltageMagnitudeWithEq9(network,u_pcc_array,x_y,x_y_ast,V_ast_nopcc_stack,M_y)
        decision_variables = DefineDecisionVariables(obj)
        [x_y_ast,V_ast_nopcc_stack] = GetLinearizationXy(load_case,U_ast,T_ast)
    end
end