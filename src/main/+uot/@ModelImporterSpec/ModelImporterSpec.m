classdef (Abstract) ModelImporterSpec < uot.Spec
    % ModelImporterSpec specifies an object to import data for a multi-period
    % power flow or optimal power flow problem
    methods
        function obj = ModelImporterSpec()

        end
    end

    properties
        s_base_va(1,1) {mustBePositive} = 1e6 % base power for per unit system

        time_step_s(1,1) double {mustBeInteger,mustBePositive} = 1 % seconds between time steps
        n_time_step(1,1) double {mustBeInteger,mustBePositive} = 1 % number of time steps
    end

end
