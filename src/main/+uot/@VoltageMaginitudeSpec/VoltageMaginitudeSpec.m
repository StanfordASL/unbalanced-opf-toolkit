% Note that PowerQualitySpec does not apply to pcc
classdef VoltageMaginitudeSpec < uot.Spec
    methods
        function obj = VoltageMaginitudeSpec(varargin)
            % uot.VoltageMaginitudeSpec() no limits on voltage magnitude
            % uot.VoltageMaginitudeSpec(u_min,u_max)

            n_varargin = numel(varargin);

            switch n_varargin
                case 0
                    u_min = [];
                    u_max = [];
                case 2
                    obj.u_min = varargin{1};
                    obj.u_max = varargin{2};

                otherwise
                    error('Invalid number of arguments')
            end
        end

        function AssertSpecSatisfaction(obj,u_val,constraint_tol)
            tag_u = 'voltage maginitude';
            AssertLowerBoundSatisfaction(u_val,obj.u_min,constraint_tol,tag_u);
            AssertUpperBoundSatisfaction(u_val,obj.u_max,constraint_tol,tag_u);
        end
    end

    properties
       u_min double {mustBeNonnegative,uot.NumelMustBeLessThanOrEqual(u_min,1)};
       u_max double {mustBeNonnegative,uot.NumelMustBeLessThanOrEqual(u_max,1)};
   end
end

