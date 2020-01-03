classdef LoadCaseZIPspec < uot.AbstractLoadCaseSpec
    % LoadCaseZIPspec used to specify LoadCaseZIP objects
    methods
        function obj =  LoadCaseZIPspec(load_spec_array,time_step_s,n_time_step)
            % LoadCaseZIPspec constructs a LoadCaseZIPspec
            %   Multiple instances of uot.LoadZipSpec with the same bus
            %   will be added.
            obj@uot.AbstractLoadCaseSpec(load_spec_array,time_step_s,n_time_step);
        end

        function res = Create(obj,varargin)
            % res = Create(obj,network)
            assert(nargin == 2,'There must be exactly 2 arguments')
            res = uot.LoadCaseZIP(obj,varargin{1});
        end
    end




    properties
        % current_is_prerotated is a flag indicating if the currents are pre-rotated.
        % Gridlabd uses pre-rotated currents in its powerflow solver. Hence,
        % we use them as well when we want to match results from Gridlab.
        % Solutions to IEEE test feeders are typically more accurate using
        % non pre-rotated currents. Hence, we use them when we want to match
        % those.
        % When working with pre-rotated currents, they are injected directly to the bus
        % i_inj_a = i_y_a
        % When working with non pre-rotated currents, they are first rotated to account
        % for the angles of the different phases as in Bazrafshan2018a Eq. 3b
        % i_inj_a = i_y_a*(v_bus./(abs(v_bus)))
        % i_d_a works analogously
        % Note that derived loads i_y_va and i_d_va are always non-prerotated.
        current_is_prerotated(1,1) logical = false
    end
end














