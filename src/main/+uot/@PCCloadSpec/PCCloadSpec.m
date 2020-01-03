classdef PCCloadSpec < uot.ControllableLoadSpec
    methods
        function obj = PCCloadSpec(varargin)
            name = 'swing_load';
            attachment_bus = '';
            phase = true(1,3);

            obj@uot.ControllableLoadSpec(name,attachment_bus,phase,varargin{:});
        end
    end
end