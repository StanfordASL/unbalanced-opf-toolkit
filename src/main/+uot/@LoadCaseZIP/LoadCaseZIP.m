classdef LoadCaseZIP < uot.AbstractLoadCase
    methods
        function obj = LoadCaseZIP(spec,network)
            % LoadCaseZIP Constructs a LoadCaseZIP object
            %   LoadCaseZIP(spec,network) instantiates LoadCaseZIP with
            %   loads from the spec.

            validateattributes(spec,{'uot.LoadCaseZIPspec'},{});
            obj@uot.AbstractLoadCase(spec,network);

            % Note: S_y_va is built by uot.AbstractLoadCase
            [obj.S_d_va,obj.Y_y_siemens,obj.Y_d_siemens,...
                obj.I_y_a,obj.I_d_a] ...
                = uot.LoadCaseZIP.BuildZIPloadMatrices(spec,network,obj.bus_has_load_phase,obj.bus_has_delta_load_phase);

            % If the network has split phases, we need to remove one of
            % from Z_base_ohm and I_base_a so that the dimensions match.
            if isa(network,'uot.Network_Splitphased')
                Z_base_mat_delta = network.Z_base_ohm(:,1:4);
                Ibase_mat_delta = network.I_base_a(:,1:4);
            else
                Z_base_mat_delta = network.Z_base_ohm;
                Ibase_mat_delta = network.I_base_a;
            end

            % Note: S_y is added by uot.AbstractLoadCase
            obj.S_d = obj.S_d_va./network.spec.s_base_va;
            obj.Y_y = obj.Y_y_siemens.*network.Z_base_ohm;
            obj.Y_d = obj.Y_d_siemens.*Z_base_mat_delta;
            obj.I_y = obj.I_y_a./network.I_base_a;
            obj.I_d = obj.I_d_a./Ibase_mat_delta;
        end

        load_case_py = ConvertToLoadCasePy(obj,varargin)
    end

    properties (SetAccess = immutable, GetAccess = public)
        % S_y_va is in uot.AbstractLoadCase
        S_d_va
        Y_y_siemens
        Y_d_siemens
        I_y_a
        I_d_a

        % S_y is in uot.AbstractLoadCase
        S_d
        Y_y
        Y_d
        I_d
        I_y
    end

    % Implemented abstract methods
    methods (Access = protected)
        [I_inj_stack,I_n] = ComputeCurrentInjectionHelper(obj,V_s,V_n)
    end

    % Private elements
    methods (Access = private)
        [I_p,I_p_y,I_p_d] = GetCurrentFromPloads(obj,V)
        [I_z,I_z_y,I_z_d] = GetCurrentFromZloads(obj,V)
        [I_i,I_i_y,I_i_d] = GetCurrentFromIloads(obj,V)
    end


    methods (Static, Access = private)
        [S_d_va,Y_y_siemens,Y_d_siemens,I_y_a,I_d_a] = BuildZIPloadMatrices(spec,network,bus_has_load_phase,bus_has_delta_load_phase)
    end



end