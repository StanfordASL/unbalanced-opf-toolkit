classdef AbstractNetwork < uot.Object
    % Abstract base class with common functionality for power networks
    %
    % Description:
    %   This class builds the foundation to represent power networks.
    %
    %
    % Arguments:
    %   spec (|uot.NetworkSpec|): Network specification
    %   bus_data_array (|uot.BusData|): Array describing the buses
    %   link_data_array (|uot.LinkData|): Array describing the links
    %
    %
    % See Also:
    %   |uot.NetworkSpec|, |uot.Network_Unbalanced|, |uot.Network_Splitphased|
    %

    % .. Line with 80 characters for reference #####################################


    methods
        function obj = AbstractNetwork(spec)
            validateattributes(spec,{'uot.NetworkSpec'},{'scalar'},mfilename,'spec',1);
            obj@uot.Object(spec);

            % Bus variables
            obj.bus_data_array = obj.CreateBusDataArray(spec.bus_spec_array);

            obj.n_bus = numel(obj.bus_data_array);

            bus_has_phase = vertcat(obj.bus_data_array.phase);

            assert(size(bus_has_phase,2) == obj.n_phase,'bus_data_array.phase is not consistent with n_phase');
            obj.bus_has_phase = bus_has_phase;

            obj.bus_name_cell = {obj.bus_data_array.name}.';
            obj.bus_name_map = containers.Map(obj.bus_name_cell,1:obj.n_bus);

            obj.n_phase_in_bus = sum(obj.bus_has_phase,2);
            obj.n_bus_has_phase = sum(obj.n_phase_in_bus);

            obj.n_phase_pcc = obj.n_phase_in_bus(1);

            n_phase_in_bus_cumsum = cumsum(obj.n_phase_in_bus);
            bus_stack_start = 1 + [0;n_phase_in_bus_cumsum(1:end-1)];
            bus_stack_end = bus_stack_start + obj.n_phase_in_bus - 1;

            obj.bus_stack_index_cell = cell(obj.n_bus,1);
            for i = 1:obj.n_bus
                obj.bus_stack_index_cell{i} = bus_stack_start(i):bus_stack_end(i);
            end

            % Link variables
            s_base_va = obj.spec.s_base_va;
            obj.link_data_array = obj.CreateLinkDataArray(spec.link_spec_array,obj.bus_name_map,obj.bus_data_array,s_base_va);
            obj.n_link = numel(obj.link_data_array);

            obj.link_has_phase_from = vertcat(obj.link_data_array.phase_from);
            obj.link_has_phase_to = vertcat(obj.link_data_array.phase_to);

            obj.n_phase_from_in_link = sum(obj.link_has_phase_from,2);
            obj.n_phase_to_in_link = sum(obj.link_has_phase_to,2);

            obj.n_link_has_phase_from = sum(obj.n_phase_from_in_link);
            obj.n_link_has_phase_to = sum(obj.n_phase_to_in_link);

            link_hash = uot.HashEdgeUndirected(obj.n_bus,[obj.link_data_array.from_i],[obj.link_data_array.to_i]);
            obj.link_hash_map = containers.Map(link_hash,1:obj.n_link);

            obj.link_name_cell = {obj.link_data_array.name}.';
            obj.link_name_map = containers.Map(obj.link_name_cell,1:obj.n_link);

            n_phase_from_in_link_cumsum = cumsum(obj.n_phase_from_in_link);
            link_stack_start = 1 + [0;n_phase_from_in_link_cumsum(1:end-1)];
            link_stack_end = link_stack_start + obj.n_phase_from_in_link - 1;

            obj.link_stack_index_cell = cell(obj.n_link,1);
            for i = 1:obj.n_link
                obj.link_stack_index_cell{i} = link_stack_start(i):link_stack_end(i);
            end

            % Variables for per-unit system

            U_base_v = repmat([obj.bus_data_array.u_base_v].',1,obj.n_phase);
            obj.U_base_v = uot.ExtractPhaseConsistentValues(U_base_v,obj.bus_has_phase);

            obj.Z_base_ohm = obj.U_base_v.^2/s_base_va;
            obj.I_base_a = s_base_va./obj.U_base_v;

            obj.I_base_link_from_a = nan(obj.n_link,obj.n_phase);
            obj.I_base_link_to_a = nan(obj.n_link,obj.n_phase);

            for i = 1:obj.n_link
                from_i = obj.link_data_array(i).from_i;
                phase_from = obj.link_data_array(i).phase_from;

                to_i = obj.link_data_array(i).to_i;
                phase_to = obj.link_data_array(i).phase_to;

                obj.I_base_link_from_a(i,phase_from) = obj.I_base_a(from_i,phase_from);
                obj.I_base_link_to_a(i,phase_to) = obj.I_base_a(to_i,phase_to);
            end

            U_base_stack_v = uot.StackPhaseConsistent(obj.U_base_v,obj.bus_has_phase);
            Zbus_base_ohm = (U_base_stack_v*U_base_stack_v.')/s_base_va;
            % TODO: test this
            obj.Ybus_base_siemens = 1./Zbus_base_ohm;

            % Graph theoretical variables
            [obj.connectivity_graph,obj.is_radial] = obj.CreateConnectivityGraph();

            % Ybus
            obj.Ybus = obj.ComputeYbus();

            [obj.Ybus_SS, obj.Ybus_SN, obj.Ybus_NS, obj.Ybus_NN,obj.Ybus_NN_L,obj.Ybus_NN_U] = obj.PartitionYbus();

            % Shunts
            obj.Y_shunt_bus_cell = obj.CreateYshuntBusCell();

            shunt_norm = cellfun(@(Y_shunt) norm(full(Y_shunt),2),obj.Y_shunt_bus_cell);

            shunt_tol = 1e-6;
            if any(shunt_norm >=  shunt_tol)
                obj.has_shunts = true;
            else
                obj.has_shunts = false;
            end
        end

        [adjacency_list_cell,inv_adjacency_list_cell] = ComputeAdjacencyList(obj)
        I_inj_array = ComputeCurrentInjectionFromVoltage(obj,U_array,T_array)
        [I_link_from_array,I_link_to_array,S_link_from_array,S_link_to_array] = ComputeLinkCurrentsAndPowers(obj,U_array,T_array)
        [U_noload_array,T_noload_array,w] = ComputeNoLoadVoltage(obj,u_pcc_array,t_pcc_array)
        [P_inj_array,Q_inj_array] = ComputePowerInjectionFromVoltage(obj,U_array,T_array)
        bus_number_array = GetBusNumber(obj,bus_name_array)
        link_number = GetLinkNumber(obj,varargin)
        v_flat = GetFlatVoltage(obj)
        Y_shunt_bus = GetYshuntBus(obj,i_bus)
    end

    properties (GetAccess = public, SetAccess = immutable)
        % Bus variables
        bus_data_array
        n_bus
        bus_has_phase
        bus_name_cell
        bus_has_load
        n_phase_in_bus
        n_phase_pcc
        n_bus_has_phase
        bus_stack_index_cell

        % Link variables
        link_data_array
        n_link
        link_has_phase_from
        link_has_phase_to
        link_name_cell
        n_phase_from_in_link
        n_phase_to_in_link
        n_link_has_phase_from
        n_link_has_phase_to
        link_stack_index_cell

        % Variables for per-unit system
        U_base_v
        Z_base_ohm
        I_base_a
        I_base_link_from_a
        I_base_link_to_a
        Ybus_base_siemens

        % Graph theoretic variables
        connectivity_graph
        is_radial

        % Ybus variables
        Ybus
        Ybus_SS
        Ybus_SN
        Ybus_NS
        Ybus_NN
        Ybus_NN_L
        Ybus_NN_U

        % Shunts
        Y_shunt_bus_cell
        has_shunts
    end

    properties
       Y_shunt_bus_prec(1,1) double {mustBeInteger, mustBePositive} = 10 % Rounding precision of Y_shunt_bus to remove numerical noise. See CreateYshuntBusCell.
    end

    properties (Constant, Abstract)
        n_phase
        phase_primary
    end

    properties (GetAccess = private, SetAccess = immutable)
        bus_name_map
        link_hash_map
        link_name_map
    end

    methods (Abstract, Access = protected)
        bus_data = MapBusSpecToBusData(obj,bus_spec)
        link_data = MapLinkSpecToLinkData(obj,link_spec,from_i,to_i,bus_spec_from,bus_spec_to,s_base_va)
    end

    methods (Access = private)
        Ybus = ComputeYbus(obj)
        [connectivity_graph,is_radial] = CreateConnectivityGraph(obj)
        bus_data_array = CreateBusDataArray(obj,bus_spec_array)
        link_data_array = CreateLinkDataArray(obj,link_spec_array,bus_name_map,bus_data_array,s_base_va)
        Y_shunt_bus_cell = CreateYshuntBusCell(obj)
        [Ybus_SS, Ybus_SN, Ybus_NS, Ybus_NN,Ybus_NN_L,Ybus_NN_U] = PartitionYbus(obj)
    end
end
