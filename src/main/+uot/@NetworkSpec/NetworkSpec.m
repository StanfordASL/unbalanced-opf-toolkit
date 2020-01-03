classdef NetworkSpec < uot.Spec & uot.Factory
    % NetworkSpec class to specify power networks
    methods
        function obj = NetworkSpec(bus_spec_array,link_spec_array,varargin)

            obj.bus_spec_array = bus_spec_array(:);
            obj.link_spec_array = link_spec_array(:);

            p = inputParser;

            addParameter(p,'s_base_va',1e6);

            parse(p,varargin{:});

            obj.s_base_va = p.Results.s_base_va;
        end
    end

    properties
        bus_spec_array(1,:) uot.AbstractBusSpec % array of bus specifications
        link_spec_array(1,:) uot.AbstractLinkSpec % array of link specifications
        s_base_va(1,1) double {mustBePositive,mustBeReal} = 1 % base power for per unit system
        is_positively_sequenced(1,1) logical = true; % flag to note if network is operated with possitively sequenced voltages or with negatively sequenced voltages. See VoltageIsPositivelySequenced. Irelevant for single-phase.
    end

    % Implemented methods from uot.Factory
    methods
        network = Create(obj)
    end
end