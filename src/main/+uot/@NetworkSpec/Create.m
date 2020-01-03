function network = Create(obj)
% Create an |uot.AbstractNetwork| based on this spec.
%
% Synopsis::
%
%   network = spec..Create()
%
% Description:
%   There is only one |uot.NetworkSpec| but multiple subclasses of |uot.AbstractNetwork|.
%   This method instantiates the correct subclass based on the spec.
%
%   Implements :meth:`uot.Factory.Create<+uot.@Factory.Factory.Create>`
%
% Returns:
%
%   - **network** (|uot.AbstractNetwork|) - Intantiated network based on this |uot.NetworkSpec|

% .. Line with 80 characters for reference #####################################


% Determine network type
if isa(obj.bus_spec_array,'uot.BusSpec_Unbalanced') ...
        && isa(obj.link_spec_array,'uot.LinkSpec_Unbalanced')
    network = uot.Network_Unbalanced(obj);
else
    network = uot.Network_Splitphased(obj);
end
end