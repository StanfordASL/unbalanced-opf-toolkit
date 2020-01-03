% In the case of an undirected graph, edge 1,2 or 2,1 is the same. Hence, we hash using souce as the least of source and sink
function res = HashEdgeUndirected(n_bus,source_pre,sink_pre)
% HashEdgeUndirected assigns a unique value to an undirected graph's edge
source = min(source_pre,sink_pre);
sink = max(source_pre,sink_pre);
res = uot.HashEdge(n_bus,source,sink);
end