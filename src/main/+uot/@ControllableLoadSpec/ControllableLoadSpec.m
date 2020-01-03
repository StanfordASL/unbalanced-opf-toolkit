classdef ControllableLoadSpec < uot.Spec
    methods
        function obj = ControllableLoadSpec(name,attachment_bus,phase,varargin)
            % Allow no-argument constructor for pre-allocation
            if nargin > 0
                % Constraints must be given as scalar or 1x3

                obj.name = name;
                obj.attachment_bus = attachment_bus;
                assert(size(phase,1) == 1);
                obj.phase = phase;

                p = inputParser;

                addParameter(p,'p_min_va',[]);
                addParameter(p,'p_max_va',[]);
                addParameter(p,'q_min_va',[]);
                addParameter(p,'q_max_va',[]);

                addParameter(p,'power_factor_min',[]);
                addParameter(p,'power_factor_max',[]);

                addParameter(p,'s_mag_max_va',[]);
                addParameter(p,'s_sum_mag_max_va',[]);

                addParameter(p,'p_delta_max_va',[]);
                addParameter(p,'q_delta_max_va',[]);

                parse(p,varargin{:});

                obj.p_min_va = p.Results.p_min_va;
                obj.p_max_va = p.Results.p_max_va;
                obj.q_min_va = p.Results.q_min_va;
                obj.q_max_va = p.Results.q_max_va;

                obj.power_factor_min = p.Results.power_factor_min;
                obj.power_factor_max = p.Results.power_factor_max;

                obj.s_mag_max_va = p.Results.s_mag_max_va;
                obj.s_sum_mag_max_va = p.Results.s_sum_mag_max_va;

                obj.p_delta_max_va = p.Results.p_delta_max_va;
                obj.q_delta_max_va = p.Results.q_delta_max_va;
            end
        end

        function n_phase = get.n_phase(obj)
            n_phase = sum(obj.phase);
        end

        AssertSpecSatisfaction(obj,p_val_va,q_val_va,constraint_tol);
    end

    properties
        name(1,:) char;
        attachment_bus(1,:) char;
        phase(1,:) logical {uot.MustBeMustBeUnbalancedPhaseVectorOrEmpty(phase)};

        p_min_va(:,:) double;
        p_max_va(:,:) double;
        q_min_va(:,:) double;
        q_max_va(:,:) double;

        power_factor_min(:,:) double {mustBeNonnegative};
        power_factor_max(:,:) double {mustBeNonpositive};

        s_mag_max_va(:,:)  double {mustBeNonnegative};
        s_sum_mag_max_va(:,1) double {mustBeNonnegative};

        p_delta_max_va(:,:)  double {mustBeNonnegative};
        q_delta_max_va(:,:)  double {mustBeNonnegative};
    end

    properties (Dependent)
        n_phase
    end
end

