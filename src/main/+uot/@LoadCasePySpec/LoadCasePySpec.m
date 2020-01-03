classdef LoadCasePySpec < uot.AbstractLoadCaseSpec
    % LoadCasePySpec used to specify LoadCasePySpec objects
    methods
        function obj =  LoadCasePySpec(load_spec_array,time_step_s,n_time_step)
            obj@uot.AbstractLoadCaseSpec(load_spec_array,time_step_s,n_time_step);
        end

        function res = Create(obj,varargin)
            % res = Create(obj,network)
            assert(nargin == 2,'There must be exactly 2 arguments')
            res = uot.LoadCasePy(obj,varargin{1});
        end
    end
end














