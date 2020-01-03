classdef BusData
    % BusData holds BusSpec and phase information which is later used to build
    % network.bus_has_phase. BusData also defines the numbering of the
    % buses in the network with bus 1 being the pcc

    methods
        function obj = BusData(spec,phase)
            if nargin > 0
                obj.spec = spec;
                obj.phase = phase;
            end
        end

        function res = get.name(obj)
            res = obj.spec.name;
        end

        function res = get.u_base_v(obj)
            res = obj.spec.u_nom_v;
        end
    end

    properties (Dependent)
        % Calling network.bus_data_array.spec.name does not work, so we add
        % this so that network.bus_data_array.name works
        name
        u_base_v
    end

    properties
        spec uot.AbstractBusSpec {uot.NumelMustBeLessThanOrEqual(spec,1)}
        phase logical {uot.AssertIsPhaseVectorOrEmpty}
    end
end