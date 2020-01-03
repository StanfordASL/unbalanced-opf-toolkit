classdef Network_Prunned < uot.Network_Unbalanced
    % Class to represent prunned power networks
    %
    % Description:
    %  The process of prunning a network consists in cutting away certain links
    %  and replacing them with constant loads. This class is meant to deal with 
    %  these objects that are represented by a network and a load case.
    %
    % Synopsis::
    %
    %   obj = Network_Prunned(network_full,removed_bus_name_cell,cut_link_name_cell)
    %
    % Arguments:
    %   network_full (|uot.AbstractNetwork|): Full network
    %   removed_bus_name_cell (cell): Cell array with the names of buses to be removed
    %   cut_link_name_cell (cell): Cell array with the names of the links to be cut and replaced with loads

    methods
        function obj = Network_Prunned(network_full,removed_bus_name_cell,cut_link_name_cell)
            validateattributes(network_full,{'uot.Network_Splitphased'},{'scalar'})
            validateattributes(removed_bus_name_cell,{'cell'},{})
            validateattributes(cut_link_name_cell,{'cell'},{})

            % Verify that all buses in removed_bus_name_cell are in network
            assert(all(isfinite(network_full.GetBusNumber(removed_bus_name_cell))),'Not all removed_bus_name_cell are buses in network_full.')
            % Verify that all links in cut_link_name_cell are in network
            assert(all(isfinite(network_full.GetLinkNumber(cut_link_name_cell))),'Not all cut_link_name_cell are links in network_full.')

            % Verify removed_bus_name_cell does not include any from-bus of cut_link_name_cell
            % We use dummy values so that the map works as a set
            removed_bus_name_map = containers.Map(removed_bus_name_cell,zeros(size(removed_bus_name_cell)));

            i_cut_link_array = network_full.GetLinkNumber(cut_link_name_cell);
            cut_link_from_name_cell = {network_full.link_data_array(i_cut_link_array).from};

            assert(all(~removed_bus_name_map.isKey(cut_link_from_name_cell)),'From-buses of links in cut_link_name_cell may not be in removed_bus_name_cell.')

            spec = uot.Network_Prunned.CreateSpec(network_full,removed_bus_name_map);
            obj@uot.Network_Unbalanced(spec)

            obj.network_full = network_full;
            obj.removed_bus_name_map = removed_bus_name_map;
            obj.cut_link_name_cell = cut_link_name_cell;
        end

         load_case = AdaptLoadCase(obj,load_case_full,u_pcc_array,t_pcc_array)
         bus_in_orginal = GetBusInOriginal(obj)

    end

    properties (GetAccess = public, SetAccess = immutable)
        network_full
        removed_bus_name_map
        cut_link_name_cell
    end

    properties
        validate(1,1) logical = true % Flag to validate AdaptLoadCase against original power flow solution
        validate_tol(1,1) double {mustBePositive} = 1e-8 % Absolute tolerance to validate AdaptLoadCase
    end

    methods (Static, Access = private)
       spec = CreateSpec(network_full,removed_bus_name_cell)
    end
end