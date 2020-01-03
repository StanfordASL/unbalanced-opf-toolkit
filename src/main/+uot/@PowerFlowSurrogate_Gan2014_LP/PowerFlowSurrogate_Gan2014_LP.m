classdef PowerFlowSurrogate_Gan2014_LP < uot.PowerFlowSurrogate_Gan2014
    % Implements the linear power flow surrogate presented in :cite:`Gan2014`.
    %
    % Synopsis::
    %
    %   obj = uot.PowerFlowSurrogate_Gan2014_LP(spec,opf_problem)
    %
    % Description:
    %   This power flow surrogate is derived from the branch flow model SDP used 
    %   in |uot.PowerFlowSurrogate_Gan2014_SDP| by assuming fixed ratios of 
    %   voltages between phases in a bus and fixed line losses.
    %
    %   This implementation does not keep track of phase since it is not
    %   necessary for implementing the required constraints.
    %
    % Arguments:
    %   spec (|uot.PowerFlowSurrogateSpec_Gan2014_LP|): Object specification
    %   opf_problem (|uot.OPFproblem|): OPF problem where the power flow surrogate will be used
    %
    % Note:
    %   This implementation uses the linearization method from :cite:`Sankur2016`. 
    %   The linearization used in the original paper :cite:`Gan2014` is a special
    %   case that can be recovered by setting::
    %
    %       pf_surrogate.linearization_point = uot.enum.CommonLinearizationPoints.FlatVoltage
    %
    %
    % Example::
    %
    %   % This class should be instantiated via its specification
    %   spec = uot.PowerFlowSurrogateSpec_Gan2014_LP();
    %   pf_surrogate = spec.Create(opf_problem);
    %
    % See Also:
    %   |uot.PowerFlowSurrogateSpec_Gan2014_LP|

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = PowerFlowSurrogate_Gan2014_LP(spec,opf_problem)
            validateattributes(spec,{'uot.PowerFlowSurrogateSpec_Gan2014_LP'},{'scalar'},mfilename,'spec',1);
            decision_variables = uot.PowerFlowSurrogate_Gan2014_LP.DefineDecisionVariables(opf_problem);
            obj@uot.PowerFlowSurrogate_Gan2014(spec,opf_problem,decision_variables)
        end

        constraint_array = GetConstraintArray(obj) % Abstract method from uot.AbstractPowerFlowSurrogate
    end

    properties
        linearization_point(1,1) uot.enum.CommonLinearizationPoints = uot.enum.CommonLinearizationPoints.PFbaseCaseFirstTimeStep
    end

    methods (Static)
        [U_array,T_array, p_pcc_array, q_pcc_array,opf_problem] = SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array) % Abstract method from uot.AbstractPowerFlowSurrogate class
        [U_array,T_array, p_pcc_array, q_pcc_array] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,varargin)
    end

    % Protected

    % Implemented abstract methods from uot.AbstractPowerFlowSurrogate
    methods (Access = {?uot.AbstractPowerFlowSurrogate,?uot.OPFproblem})
        [U_array,T_array] = ComputeVoltageEstimate(obj) % Abstract method from uot.AbstractPowerFlowSurrogate
        function [U_array,T_array,p_pcc_array,q_pcc_array] = AssignBaseCaseSolution(obj)
            % Assigns the base case solution
            %
            % Todo:
            %
            %   - This needs to be implemented
            
            
            U_array = [];
            T_array = [];
            p_pcc_array = [];
            q_pcc_array = [];
        end
    end

    methods (Static, Access = protected)
       decision_variables = DefineDecisionVariables(opf_problem)
    end

    % Private
    methods (Access = private)
       L_link_cell = ComputeConstantLinkCurrents(obj,U_array,T_array)
    end

    methods (Static, Access = private)
        gamma_mat = GetGammaMatrix()
    end
end