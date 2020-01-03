function network_prunned = CreateNetworkWithPrunedSecondaries(obj)
% Create a new network that results from prunning the split-phased secondaries
%
% Synopsis::
%
%   network_prunned = network.CreateNetworkWithPrunedSecondaries()
%
% See Also:
%   |uot.Network_Prunned|
    

link_is_spct = arrayfun(@(link_data) isa(link_data.spec,'uot.LinkSpec_SPCT'),obj.link_data_array);

cut_link_spec_array = [obj.link_data_array(link_is_spct).spec].';

n_cut_link_spec_array = numel(cut_link_spec_array);

removed_bus_name_cell_pre = cell(n_cut_link_spec_array,1);

for i_cut_link_spec_array = 1:n_cut_link_spec_array
    cut_link_spec = cut_link_spec_array(i_cut_link_spec_array);

    i_to_bus = obj.GetBusNumber(cut_link_spec.to);
    i_from_bus = obj.GetBusNumber(cut_link_spec.from);

    % Start searching for buses downstream of the to-end of the SPCT
    i_bus_for_removal_array = dfsearch(obj.connectivity_graph,i_to_bus,'discovernode');

    % Verify that we did not arrive at the from-end of the SPCT. This would
    % mean that there is a cycle and, thus, the subgraph to be pruned is not
    % a tree. We only support prunning tree subgraphs.
    if ~isempty(find(i_bus_for_removal_array == i_from_bus,1) > 0)
        error('Subgraph for pruning starting at bus %s is not a tree',cut_link_spec.name);
    end

    remove_bus_spec = [obj.bus_data_array(i_bus_for_removal_array).spec].';

    removed_bus_name_cell_pre(i_cut_link_spec_array) = {{remove_bus_spec.name}.'};
end

removed_bus_name_cell = vertcat(removed_bus_name_cell_pre{:});

cut_link_name_cell = {cut_link_spec_array.name}.';

network_prunned = uot.Network_Prunned(obj,removed_bus_name_cell,cut_link_name_cell);
end