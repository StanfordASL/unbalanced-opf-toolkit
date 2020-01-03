classdef (Abstract) AbstractLoadCaseSpec < uot.Spec & uot.Factory
    methods
        function obj = AbstractLoadCaseSpec(load_spec_array,time_step_s,n_time_step)
            obj.load_spec_array = load_spec_array(:);

            obj.time_step_s = time_step_s;
            obj.n_time_step = n_time_step;
        end

        function obj = set.load_spec_array(obj,load_spec_array)
            if ~isempty(load_spec_array)
                switch class(obj)
                    case 'uot.LoadCasePySpec'
                        validateattributes(load_spec_array,{'uot.LoadPySpec'},{});

                    case 'uot.LoadCaseZIPspec'
                        validateattributes(load_spec_array,{'uot.LoadZipSpec'},{});

                    otherwise
                        error('Invalid class of load_spec_array')
                end
            end
            obj.load_spec_array = load_spec_array;
        end
    end

    methods (Abstract)
        % From uot.Factory
        res = Create(obj,varargin)
    end

    properties
        load_spec_array(:,1) % We do type checking in set.load_spec_array

        time_step_s(1,1) double {mustBeInteger,mustBePositive} = 1;
        n_time_step(1,1) double {mustBeInteger,mustBePositive} = 1;

        start_date_time(1,1) datetime = datetime('01-Jan-2010 00:00:00','TimeZone','America/Los_Angeles') % datetime of first time step
    end
end