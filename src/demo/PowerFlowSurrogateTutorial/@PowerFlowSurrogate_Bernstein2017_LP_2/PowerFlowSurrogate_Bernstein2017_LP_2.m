classdef PowerFlowSurrogate_Bernstein2017_LP_2 < uot.AbstractPowerFlowSurrogate
    % Template class for uot.Object.
    %
    % Synopsis::
    %
    %   obj = uot.ObjectTemplate(spec,'param1',val1)
    %
    % Description:
    %   This class is intended as a starting point to develop classes that
    %   derive from ``uot.Object``.
    %
    %
    %   We can also itemize
    %
    %     - item 1
    %     - item 2
    %
    % Arguments:
    %   spec (|uot.SpecTemplate|): Object specification
    %
    % Keyword Arguments:
    %   'param1' (:class:`uot.PCCloadSpec<+uot.@PCCloadSpec.PCCloadSpec>`): Parameter
    %
    %
    % Note:
    %  Possibly add a note here
    %
    % Example::
    %
    %   object = uot.ObjectTemplate(uot.SpecTemplate())
    %
    % See Also:
    %   |uot.SpecTemplate|
    %
    % Todo:
    %
    %   - Write documentation
    %

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = PowerFlowSurrogate_Bernstein2017_LP_2(spec,opf_problem)
            validateattributes(spec,{'PowerFlowSurrogateSpec_Bernstein2017_LP_2'},{'scalar'},mfilename,'spec',1);

            decision_variables = [];
            obj@uot.AbstractPowerFlowSurrogate(spec,opf_problem,decision_variables)
        end

        constraint_array = GetConstraintArray(obj) % Abstract method from uot.AbstractPowerFlowSurrogate
    end

    methods (Static)
        [U_array,T_array,p_pcc_array,q_pcc_array,opf_problem] = SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array) % Abstract method from uot.AbstractPowerFlowSurrogate class
        [U_array,T_array, p_pcc_array, q_pcc_array,extra_data] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,varargin)
    end

    % Protected
    methods (Access = {?uot.AbstractPowerFlowSurrogate,?uot.OPFproblem})
        [U_array,T_array,p_pcc_array,q_pcc_array] = AssignBaseCaseSolution(obj) % Abstract method from uot.AbstractPowerFlowSurrogate
        [U_array,T_array] = ComputeVoltageEstimate(obj) % Abstract method from uot.AbstractPowerFlowSurrogate
    end
end