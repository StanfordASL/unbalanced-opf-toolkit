classdef Network_Unbalanced < uot.AbstractNetwork
    % Class to represent unbalanced power networks
    %
    % Synopsis::
    %
    %   network = uot.Network_Unbalanced(spec)
    %
    % Description:
    %   This class is used to represent unbalanced power networks
    %
    % Arguments:
    %   spec (|uot.NetworkSpec|): Network specification
    %
    % Note:
    %  Using the constructor directly is not recommended. Instead, create the object
    %  through the factory method :meth:`uot.NetworkSpec.Create<+uot.@NetworkSpec.Create>`
    %
    % See Also:
    %   |uot.AbstractNetwork|, |uot.NetworkSpec|

    % .. Line with 80 characters for reference #####################################


    methods
        function obj = Network_Unbalanced(spec)
            validateattributes(spec,{'uot.NetworkSpec'},{'scalar'},mfilename,'spec',1);
            obj@uot.AbstractNetwork(spec);
        end
    end

    % Implemented from uot.AbstractNetwork
    properties (Constant)
        n_phase = 3;
        phase_primary = logical([1,1,1]);
    end

    % Implemented from uot.AbstractNetwork
    methods (Access = protected)
       bus_data = MapBusSpecToBusData(obj,bus_spec)
       link_data = MapLinkSpecToLinkData(obj,link_spec,from_i,to_i,bus_spec_from,bus_spec_to,s_base_va)
    end
end