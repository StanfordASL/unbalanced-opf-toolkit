classdef OPFproblem < uot.Problem
    % Class to represent Optimal Power Flow problems
    %
    % Synopsis::
    %
    %   opf_problem = uot.OPFproblem(spec,load_case)
    %
    % Description:
    %   This class helps to formulate and solve unbalanced OPF problems
    %
    % Arguments:
    %   spec (|uot.OPFspec|): Specification of the OPF problem
    %   load_case (|uot.LoadCasePy|): Model of uncontrollable loads
    %
    % Note:
    %   The OPF formulation considers only wye-connected constant power loads,
    %   represented in an |uot.LoadCasePy| object. The reason is that more detailed
    %   models are typically non-convex :cite:`Taylor2015`.
    %   If loads are specified using the ZIP model, delta-to-wye conversions for some
    %   loads and approximating constant current and constant impedance loads as
    %   constant power ones is necessary. This can be done using
    %   :meth:`uot.LoadCaseZip.ConvertToLoadCasePy<+uot.@LoadCaseZip.ConvertToLoadCasePy>`.
    %

    % .. Line with 80 characters for reference #####################################


    methods
        function obj = OPFproblem(spec,load_case)
            % Allow no-argument constructor for preallocation
            if nargin == 0
                spec = uot.OPFspec();
            end
            % OPFproblem does not have decision variables as such
            decision_variables = [];
            obj@uot.Problem(spec,decision_variables);

            if nargin > 0
                validateattributes(spec,{'uot.OPFspec'},{'scalar'},mfilename,'spec',1);

                assert(isa(load_case.network,'uot.Network_Unbalanced'),'OPFproblem only supports uot.Network_Unbalanced.')

                obj.load_case = load_case;

                obj.pf_surrogate = spec.pf_surrogate_spec.Create(obj);

                obj.pcc_load = uot.ControllableLoad(obj.spec.pcc_load_spec,obj);

                obj.controllable_load_hashtable = obj.CreateControllableLoadHashTable();
            end
        end

        AssertConstraintSatisfaction(obj)
        [U_array,T_array,p_pcc_array,q_pcc_array] = AssignBaseCaseSolution(obj)
        load_case_new = CreateLoadCaseIncludingControllableLoadValues(obj)
        load_case = CreateLoadCaseWithControllableLoadValues(obj)
        [p_pcc_array_val,q_pcc_array_val] = EvaluatePowerInjectionFromPCCload(obj)
        [U_array,T_array] = GetVoltageEstimate(obj)
        [U_array,T_array,p_pcc_array,q_pcc_array]  = SolvePFbaseCase(obj)
        [U_array,T_array,p_pcc_array,q_pcc_array]  = SolvePFwithControllableLoadValues(obj)
        ValidateSpec(obj)

        % Implemented from uot.ConstraintProvider
        constraint_array = GetConstraintArray(obj)

        function n_time_step = get.n_time_step(obj)
            n_time_step = obj.load_case.spec.n_time_step;
        end

        % Convenience dependent properties
        function network = get.network(obj)
            network = obj.load_case.network;
        end

        function s_base_va = get.s_base_va(obj)
            s_base_va = obj.network.spec.s_base_va;
        end

        function u_pcc_array = get.u_pcc_array(obj)
            u_pcc_array = obj.spec.pcc_voltage_spec.u_pcc_array;
        end

        function t_pcc_array = get.t_pcc_array(obj)
            t_pcc_array = obj.spec.pcc_voltage_spec.t_pcc_array;
        end
    end

    properties
        load_case(:,:) uot.LoadCasePy {uot.NumelMustBeLessThanOrEqual(1,load_case)}
        pf_surrogate {uot.AssertIsInstance(pf_surrogate,'uot.AbstractPowerFlowSurrogate'),uot.NumelMustBeLessThanOrEqual(1,pf_surrogate)}

        linearize_magnitude_constraints(1,1) logical = false
        n_faces(1,1) double {mustBeInteger,mustBePositive} = 12
    end


    properties (Dependent)
        n_time_step % This is just for convenience
        network % This is just for convenience
        s_base_va % This is just for convenience

        u_pcc_array % This is just for convenience
        t_pcc_array % This is just for convenience
    end

    % Implemented methods from uot.Problem
    methods (Access = protected)
        objective = GetObjective(obj)
    end

    methods (Access = {?uot.AbstractPowerFlowSurrogate,?uot.OPFproblem})
        [P_inj_array,Q_inj_array] = ComputeNodalPowerInjection(obj)
        [p_pcc_array,q_pcc_array] = GetPowerInjectionFromPCCload(obj)
    end

    methods (Access = private)
        AssignControllableLoadsToNoLoad(obj)
        controllable_load_hashtable = CreateControllableLoadHashTable(obj)
        load_spec_array = CreateLoadSpecArrayWithControllableLoadValues(obj)
        objective = DefineObjective_LoadCost(obj,objective_spec)
        controllable_load_constraint_array = GetControllableLoadConstraintArray(obj)
        [P_inj_controllable_array,Q_inj_controllable_array] = GetPowerInjectionFromControllableLoads(obj)
        ValidateObjectiveSpec(obj)
        ValidateObjectiveSpec_LoadCost(obj)
    end

    properties (Access = private)
        controllable_load_hashtable
        pcc_load
        U_array_cache
        T_array_cache
    end
end