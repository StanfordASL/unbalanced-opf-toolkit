%A digraph can have at most n^2 edges because each of n nodes can be
%connected to at most n other nodes (including itself).
function res = HashEdge(n_bus,source,sink)
% HashEdge assigns a unique value to an undirected graph's edge
    res = n_bus*(source - 1) + sink -1;
end