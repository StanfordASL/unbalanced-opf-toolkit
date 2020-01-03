function [adjacency_list_cell,inv_adjacency_list_cell] = ComputeAdjacencyList(obj)
adjacency_list_cell = ComputeAdjacencyListHelper(obj.connectivity_graph);

connectivity_graph_inv = flipedge(obj.connectivity_graph);
inv_adjacency_list_cell = ComputeAdjacencyListHelper(connectivity_graph_inv);
end

function adjacency_list_cell = ComputeAdjacencyListHelper(graph)
% Based on https://stackoverflow.com/questions/33131082/adjacency-lists-of-a-graph-in-matlab
adjacency_mat = graph.adjacency;
[R,C] = find(adjacency_mat);
adjacency_list_cell = accumarray(R, C, [graph.numnodes,1], @(x) {sort(x)});
end