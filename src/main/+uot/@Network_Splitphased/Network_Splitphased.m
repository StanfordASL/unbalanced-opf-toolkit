classdef Network_Splitphased < uot.AbstractNetwork
    % Class to represent unbalanced power networks with split phases
    %
    % Synopsis::
    %
    %  network = uot.Network_Splitphased(spec)
    %
    % Description:
    %   This class is used to represent unbalanced power networks with split phases
    %
    % Arguments:
    %   spec (|uot.NetworkSpec|): Network specification
    %
    % Note:
    %   Using the constructor directly is not recommended. Instead, create the object
    %   through the factory method :meth:`uot.NetworkSpec.Create<+uot.@NetworkSpec.Create>`::
    %
    %       network = spec.Create()
    %
    % See Also:
    %   |uot.AbstractNetwork|, |uot.NetworkSpec|

    % .. Line with 80 characters for reference #####################################


    methods
        function obj = Network_Splitphased(spec)
            validateattributes(spec,{'uot.NetworkSpec'},{'scalar'},mfilename,'spec',1);
            obj@uot.AbstractNetwork(spec)

            obj.bus_has_split_phase = all(obj.bus_has_phase(:,obj.phase_secondary),2);
        end
    end

    properties (GetAccess = public, SetAccess = immutable)
       bus_has_split_phase
    end

    % Implemented from uot.AbstractNetwork
    properties (Constant)
        n_phase = 5;
        phase_primary = logical([1,1,1,0,0]);
    end

    properties (Constant)
       phase_secondary = logical([0,0,0,1,1]);
    end

    % Implemented from uot.AbstractNetwork
    methods (Access = protected)
       bus_data = MapBusSpecToBusData(obj,bus_spec)
       link_data = MapLinkSpecToLinkData(obj,link_spec,from_i,to_i,bus_spec_from,bus_spec_to,s_base_va)
    end


end