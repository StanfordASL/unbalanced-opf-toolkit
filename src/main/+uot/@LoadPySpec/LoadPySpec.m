classdef LoadPySpec < uot.AbstractLoadSpec
    % uot.LoadPySpec Specifies a wye-connected constant power load
    %   This class is just a thin wrapper over uot.AbstractLoadSpec
    methods
        function obj = LoadPySpec(bus,s_y_va)
            % uot.LoadPySpec Constructs a LoadPySpec object to specify a wye-connected constant power load
            %   obj = LoadPySpec(bus,s_y_va)
            %   bus is the name of the bus to which the load is connected,
            %   s_y_va specifies constant complex power wye-connected load in volt-ampere,

            obj@uot.AbstractLoadSpec(bus)
            obj.s_y_va = s_y_va;
        end
    end
end