classdef PowerFlowSurrogate_Bernstein2017_LP < uot.AbstractPowerFlowSurrogate
    % Implements the power flow surrogate presented in :cite:`Bernstein2017`
    %
    % Synopsis::
    %
    %   obj = uot.PowerFlowSurrogate_Bernstein2017_LP(spec,opf_problem)
    %
    % Description:
    %   This power flow surrogate uses an explicit linear formulation to 
    %   approximate the power flow equation.  The formulation is based on the 
    %   fixed-point solution to the power flow equation.
    %
    %   This implementation does not keep track of phase since it is not
    %   necessary for implementing the required constraints.
    %
    % Arguments:
    %   spec (|uot.PowerFlowSurrogateSpec_Bernstein2017_LP|): Object specification
    %   opf_problem (|uot.OPFproblem|): OPF problem where the power flow surrogate will be used
    %
    % Note:
    %   The paper considers the possibility of delta-connected loads. However, we
    %   do not use them here since |uot.OPFproblem| does not support them.
    %
    %
    % Example::
    %
    %   % This class should be instantiated via its specification
    %   spec = uot.PowerFlowSurrogateSpec_Bernstein2017_LP();
    %   pf_surrogate = spec.Create(opf_problem);
    %
    % See Also:
    %   |uot.PowerFlowSurrogateSpec_Bernstein2017_LP|

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = PowerFlowSurrogate_Bernstein2017_LP(spec,opf_problem)
            validateattributes(spec,{'uot.PowerFlowSurrogateSpec_Bernstein2017_LP'},{'scalar'},mfilename,'spec',1);

            decision_variables = uot.PowerFlowSurrogate_Bernstein2017_LP.DefineDecisionVariables(opf_problem);
            obj@uot.AbstractPowerFlowSurrogate(spec,opf_problem,decision_variables)
        end

        constraint_array = GetConstraintArray(obj) % Abstract method from uot.AbstractPowerFlowSurrogate
    end

    methods (Static)
        [U_array,T_array,p_pcc_array,q_pcc_array,opf_problem] = SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array) % Abstract method from uot.AbstractPowerFlowSurrogate class
        [U_array,T_array, p_pcc_array, q_pcc_array,extra_data] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,varargin)
    end

    properties
        linearization_point(1,1) uot.enum.CommonLinearizationPoints = uot.enum.CommonLinearizationPoints.FlatVoltage % Linearization point (|uot.enum.CommonLinearizationPoints|)
    end

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