classdef (Abstract) AbstractPowerFlowSurrogate < uot.ConstraintProvider
    % Interface to implement power flow surrogates
    %
    % Description:
    %   This abstract class specifies the interface to implement power flow
    %   surrogates.
    %
    % Arguments:
    %   spec (|uot.AbstractPowerFlowSurrogateSpec|): Power flow surrogates
    %       specification
    %   opf_problem (|uot.OPFproblem|): OPF problem
    %   decision_variables (struct): Struct with decision variables (as sdpvars)
    
    % .. Line with 80 characters for reference #####################################

    methods
        function obj = AbstractPowerFlowSurrogate(spec,opf_problem,decision_variables)
            obj@uot.ConstraintProvider(spec,decision_variables)
            obj.opf_problem = opf_problem;
        end

        AssertConstraintSatisfaction(obj)
        [U_ast,T_ast] = GetLinearizationVoltage(obj,linearization_point)

    end

    methods (Static)
        [U_array,T_array,p_pcc_array,q_pcc_array,extra_data] = SolveApproxPowerFlowAlt(load_case,u_pcc_array,t_pcc_array,varargin)
    end

    methods (Abstract, Static)
        % |static| Solves the power flow equations approximately using a power flow surrogate
        %
        % Synopsis::
        %
        %   [U_array,T_array,p_pcc_array,q_pcc_array,opf_problem] = PowerFlowSurrogate_Bernstein2017_LP.SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array)
        %
        % Description:
        %   Tells :meth:`uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper<main.+uot.@AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper>`
        %   which power flow surrogate to use for approximately solving the power flow equations
        %
        % Arguments:
        %   load_case (|uot.LoadCasePy|): Load case for which power flow will be approximately solved
        %   u_pcc_array (double): Array(n_phase,n_time_step) of voltage magnitudes at |pcc|
        %   t_pcc_array (double): Array(n_phase,n_time_step) of voltage angles at |pcc|
        %
        %
        % Returns:
        %
        %   - **U_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage magnitudes
        %   - **T_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage angles
        %   - **p_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with active power injection at the |pcc|
        %   - **q_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with reactive power injection at the |pcc|
        %   - **opf_problem** (|uot.OPFproblem|) - Power flow problem used to approximately solve power flow
        %
        % See Also:
        %   :meth:`uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper<+uot.@AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper>`        
        [U_array,T_array, p_pcc_array, q_pcc_array,opf_problem] = SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array)
    end

    % Protected
    % Abstract methods from uot.ConstraintProvider to be implemented
    methods (Abstract)
        % |protected| Creates the array of constraints that result from applying the power flow surrogate to the |opf| problem
        %
        % Synopsis::
        %
        %   val = pf_surrogate.GetConstraintArray()
        %
        % Description:
        %   The power flow surrogate implements at least the following constraints:
        %   - Voltage magnitude limits
        %   - Power injection at pcc
        %   - Line current limits (to be supported in a future release)
        %   - Voltage at |pcc|
        %
        % Returns:
        %
        %   - **constraint_array** (constraint) - Array of constraints
        %
        constraint_array = GetConstraintArray(obj)
    end

    methods (Abstract, Access = {?uot.AbstractPowerFlowSurrogate,?uot.OPFproblem})
        % |protected| Assigns the :term:`base case` solution to the decision variables in the surrogate. Returns approximate power flow solution that is consistent with these values.
        %
        % Synopsis::
        %
        %   [U_array,T_array,p_pcc_array,q_pcc_array] = pf_surrogate.AssignBaseCaseSolution()
        %
        % Returns:
        %
        %   - **U_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage magnitudes
        %   - **T_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage angles
        %   - **p_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with active power injection at the |pcc|
        %   - **q_pcc_array** (double) - Array (n_timestep,n_phase_pcc) with reactive power injection at the |pcc|
        %
        [U_array,T_array,p_pcc_array,q_pcc_array] = AssignBaseCaseSolution(obj)


        % |protected| Computes the estimate for complex voltages given by the power flow surrogate
        %
        % Synopsis::
        %
        %   [U_array,T_array] = pf_surrogate.ComputeVoltageEstimate()
        %
        % Returns:
        %
        %   - **U_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage magnitudes
        %   - **T_array** (double) - :term:`Phase-consistent array` (n_bus,n_phase,n_timestep) with voltage angles
        %
        [U_array,T_array] = ComputeVoltageEstimate(obj)

    end

    methods (Access = {?uot.AbstractPowerFlowSurrogate,?uot.OPFproblem})
        function objective = DefineObjective(obj,objective_spec)
            % |protected| Interface to define an objective based on the surrogate's decicision variables. 
            %
            % Synopsis::
            %   val = pf_surrogate.DefineObjective(objective_spec)
            %
            % Description:
            %   Some objectives are computed from decision variables that are specific to the 
            %   power flow surrogate (e.g., voltage). This interface allows to implement
            %   this type of objectives.
            %
            % Note:
            %   The majority of objectives can be implemented using decision variables that
            %   are common for all OPF problems and should be implemented at the level of 
            %   |uot.OPFproblem|. Thus, overriding this function is not necessary in most
            %   cases.
            %
            % Returns:
            %
            %   - **objective** (sdpvar) - Objective
            % See Also:
            %   :meth:`uot.OPFproblem.GetObjective<main.+uot.@OPFproblem.GetObjective>`
            
            % .. Line with 80 characters for reference #####################################

            
            % This method can be overriden to define additional objectives operating
            % on voltage and current variables.
            % Note: in most cases, this is not necessary.
            % See uot.OPFproblem.GetObjective
            error('%s did not override DefineObjective to implement an objective defined by %s',class(obj),class(objective_spec))
        end
    end

    properties (Access = protected)
        opf_problem(:,:) uot.OPFproblem {uot.NumelMustBeLessThanOrEqual(1,opf_problem)}
    end

    % Private
    methods (Access = private)
        AssertConstraintSatisfaction_PCCvoltage(obj,U_array_val,T_array_val)
        AssertConstraintSatisfaction_VoltageMagnitude(obj,U_array_val)
    end

    methods(Static, Access = protected)
        [U_array,T_array, p_pcc_array, q_pcc_array,opf_problem] = SolveApproxPowerFlowHelper(pf_surrogate_spec,load_case,u_pcc_array,t_pcc_array)
    end
end