function [connectivity_graph,is_radial] = CreateConnectivityGraph(obj)
% CreateConnectivityGraph Creates the network's connectivty graph (note that this graph does not contain phase information)

from_bus_array = [obj.link_data_array.from_i].';
to_bus_array = [obj.link_data_array.to_i].';

% First, we create an undirected graph to verify that the network is connected
connectivity_undirected_graph = graph(from_bus_array,to_bus_array);

% We do a graph search starting from the PCC and expect to find all buses.
pcc_bus = 1;
dfs_result = dfsearch(connectivity_undirected_graph,pcc_bus,{'edgetonew','discovernode'});

bus_array = dfs_result.Node(dfs_result.Event == 'discovernode',:);

assert(numel(bus_array) == obj.n_bus,'Network is not connected.');

% If the network is connected and has n_bus - 1 links, it is radial (i.e.,
% a tree)
is_radial = obj.n_link == obj.n_bus - 1;

if is_radial
    % Even if the network is radial, it may happen that the links' sources
    % and sinks are not specified following the convention that the source lies
    % in the unique between the sink and the PCC. To ensure that we get a
    % connectivity_graph fullfilling this property, we create it from the links
    % found in the graph search. They do follow this convention.

    link_array = dfs_result.Edge(dfs_result.Event == 'edgetonew',:);

    source_bus_array_directed = link_array(:,1);
    sink_bus_array_directed = link_array(:,2);

    connectivity_graph = digraph(source_bus_array_directed,sink_bus_array_directed,[],{obj.bus_data_array.name});
else
    connectivity_graph = digraph(from_bus_array,to_bus_array,[],{obj.bus_data_array.name});
end


end