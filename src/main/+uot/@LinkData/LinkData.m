classdef LinkData
    % LinkData is very similar to LinkSpec. The difference is that Z is
    % in pu and from and to are bus numbers instead of names.

    % Note: phase_from and phase_to do are not necessarily the same as the
    % phases in from and to buses. They are meant for SPCT transformers which
    % start with one phase and end with another

    methods
        function obj = LinkData(spec,from_i,to_i,phase_from,phase_to,u_nom_from_v,u_nom_to_v,s_base_va)
            if nargin > 0
                obj.spec = spec;

                obj.from_i = from_i;

                obj.to_i = to_i;

                obj.phase_from = phase_from;
                obj.phase_to = phase_to;

                [obj.Y_from,obj.Y_to,obj.Y_shunt_from,obj.Y_shunt_to] = spec.ComputeNormalizedAdmittanceMatrices(u_nom_from_v,u_nom_to_v,s_base_va);

                % In the case of SPCT, Y_from and Y_to are not square since
                % 1 phase becomes 2 splitphases. In this case, instead of inverting
                % the matrix we do elementwise inversion.
                if uot.IsSquareMatrix(obj.Y_from)
                    obj.Z_from = inv(obj.Y_from);
                else
                    obj.Z_from = 1./obj.Y_from;
                end

                if uot.IsSquareMatrix(obj.Y_to)
                    obj.Z_to = inv(obj.Y_to);
                else
                    obj.Z_to = 1./obj.Y_to;
                end
            end
        end

        function res = get.name(obj)
            res = obj.spec.name;
        end

        function res = get.from(obj)
            res = obj.spec.from;
        end

        function res = get.to(obj)
            res = obj.spec.to;
        end

        function res = get.from_i(obj)
            res = obj.from_i;
        end
    end

    properties (Dependent)
        % Calling network.link_data_array.spec.name does not work, so we add
        % this so that network.link_data_array.name works
        name
        from
        to
    end

    properties
        spec uot.AbstractLinkSpec {uot.NumelMustBeLessThanOrEqual(spec,1)}

        from_i(1,1) double {mustBePositive} = 1
        to_i(1,1) double {mustBePositive} = 1

        phase_from logical {uot.AssertIsPhaseVectorOrEmpty}
        phase_to logical {uot.AssertIsPhaseVectorOrEmpty}

        Y_from(:,:) double
        Y_to(:,:) double
        Y_shunt_from(:,:) double
        Y_shunt_to(:,:) double

        Z_from(:,:) double
        Z_to(:,:) double
    end
end