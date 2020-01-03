classdef (Abstract) AbstractLoadCase < uot.Object
    % Interface with common functionality for representing loads acting on a power network
    %
    % Synopsis::
    %
    %   obj = uot.AbstractLoadCase(spec,network)
    %
    % Arguments:
    %   spec (|uot.AbstractLoadCaseSpec|): Load case specification
    %   network (|uot.AbstractNetwork|): Network on which the loads act
    
    methods
        function obj = AbstractLoadCase(spec,network)
            validateattributes(spec,{'uot.AbstractLoadCaseSpec'},{});
            obj@uot.Object(spec);

            validateattributes(network,{'uot.AbstractNetwork'},{'scalar'});
            obj.network = network;

            [obj.bus_has_load_phase,obj.bus_has_delta_load_phase,obj.delta_network_matrix] = uot.AbstractLoadCase.CreateNetworkHelperMatrices(network);

            obj.S_y_va = uot.AbstractLoadCase.BuildPyLoadMatrix(spec,network,obj.bus_has_load_phase);

            obj.S_y = obj.S_y_va./network.spec.s_base_va;
        end

        function n_time_step = get.n_time_step(obj)
            n_time_step = obj.spec.n_time_step;
        end

        I_inj_array = ComputeCurrentInjection(obj,U_array,T_array)
        [P_inj_array,Q_inj_array] = ComputePowerInjection(obj,U_array,T_array)

        [U_array,T_array, p_pcc_array, q_pcc_array] = SolvePowerFlow(obj,u_pcc_array,t_pcc_array)
        ValidatePCCvoltage(obj,u_pcc_array,t_pcc_array)
    end

    properties
        pf_abs_tol(1,1) double {mustBePositive,mustBeLessThan(pf_abs_tol,1)} = 1e-9; % Absolute tolerance for solving power flow
        pf_max_iter(1,1) double {mustBeInteger,mustBePositive} = 30; % Maximal number of iterations for solving power flow
    end

    % These are for convenience
    properties (Dependent)
       n_time_step
    end

    properties (SetAccess = immutable, GetAccess = public)
        network
        S_y_va
        S_y

        bus_has_load_phase
        bus_has_delta_load_phase
        delta_network_matrix
    end

    methods (Abstract, Access = protected)
        [I_inj_stack,I_n] = ComputeCurrentInjectionHelper(obj,V_s,V_n)
    end

    methods (Access = protected)
        I_p_y_stack = GetCurrentFromPyloads(obj,V_n)
    end

    methods (Static, Access = protected)
        x = ExtractLoadVector(x_pre,x_phase,x_load_phase,n_time_step)
        VerifyLoadPhases(x,x_phase,name,n_time_step)
    end

    methods (Static, Access = private)
        S_y_va = BuildPyLoadMatrix(spec,network,bus_has_load_phase)
        [bus_has_load_phase,bus_has_delta_load_phase,delta_network_matrix] = CreateNetworkHelperMatrices(network)
    end
end