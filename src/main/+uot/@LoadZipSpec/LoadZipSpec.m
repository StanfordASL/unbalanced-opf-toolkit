classdef LoadZipSpec < uot.AbstractLoadSpec
    % uot.LoadZipSpec Specifies a ZIP load
    methods
        function obj = LoadZipSpec(bus,varargin)
            % uot.LoadZipSpec Constructs a LoadZipSpec object to specify a ZIP load
            %   obj = LoadZipSpec(bus,'param1', val1, ...) with the parameter value pairs below
            %   bus is the name of the bus to which the load is connected,
            %   's_y_va', s_y_va specifies constant complex power wye-connected load in volt-ampere,
            %   's_d_va', s_d_va specifies constant complex power delta-connected load in volt-ampere,
            %   'y_y_siemens', y_y_siemens specifies constant admitance wye-connected load in siemens,
            %   'y_d_siemens', y_d_siemens specifies constant admitance delta-connected load in siemens,
            %   'i_y_a', i_y_a specifies constant current wye-connected load in ampere,
            %   'i_d_a', i_d_a specifies constant current delta-connected load in ampere,
            %   'y_y_va', y_y_va specifies constant admitance wye-connected load in volt-ampere (automatically converted to siemens based on nominal voltage),
            %   'y_d_va', y_d_va specifies constant admitance delta-connected load in volt-ampere (automatically converted to siemens based on nominal voltage),
            %   'i_y_va', i_y_va specifies constant current wye-connected load in volt-ampere (automatically converted to ampere based on nominal voltage),
            %   'i_d_va', i_d_va specifies constant current delta-connected load in volt-ampere (automatically converted to ampere based on nominal voltage).
            %
            %   The format for specifying wye-connected loads is as follows (we use s_y_va as example, but this applies to all wye-connected loads)
            %   For unbalanced buses s_y_va must be a 1x3 vector (one entry per phase, missing phases must be set to zero)
            %   For split-phase buses s_y_va must be a 1x2 vector (one entry for phase 1, one for phase 2)
            %
            %   The format for specifying delta-connected loads is as follows (we use s_d_va as example, but this applies to all delta-connected loads)
            %   For unbalanced buses s_d_va must be a 1x3 vector (entry 1 for ab, entry 2 for bc, entry 3 for ca)
            %   For split-phase buses s_y_va must be a 1x1 vector (for 12)
            %
            %   This class does not verify that the loads are consistent with the named buses. This is done in uot.LoadCaseZip
            %
            %   See also uot.LoadCaseZIP
            obj@uot.AbstractLoadSpec(bus)

            p = inputParser;

            % Elementary loads
            addParameter(p,'s_y_va',[]);
            addParameter(p,'s_d_va',[]);
            addParameter(p,'y_y_siemens',[]);
            addParameter(p,'y_d_siemens',[]);
            addParameter(p,'i_y_a',[]);
            addParameter(p,'i_d_a',[]);

            % Derived loads
            addParameter(p,'y_y_va',[]);
            addParameter(p,'y_d_va',[]);
            addParameter(p,'i_y_va',[]);
            addParameter(p,'i_d_va',[]);

            parse(p,varargin{:});
            obj.s_y_va =  p.Results.s_y_va;
            obj.s_d_va =  p.Results.s_d_va;
            obj.y_y_siemens =  p.Results.y_y_siemens;
            obj.y_d_siemens =  p.Results.y_d_siemens;
            obj.i_y_a =  p.Results.i_y_a;
            obj.i_d_a =  p.Results.i_d_a;

            obj.y_y_va =  p.Results.y_y_va;
            obj.y_d_va =  p.Results.y_d_va;
            obj.i_y_va =  p.Results.i_y_va;
            obj.i_d_va =  p.Results.i_d_va;
        end

        function obj = times(obj,vec)
            % Overrides uot.AbstractLoadSpec.times

            % Ensure vec is a row vector so that it coincides with time dimension
            vec = vec(:);

            obj = times@uot.AbstractLoadSpec(obj,vec);

            if ~isempty(obj.s_d_va)
                obj.s_d_va = obj.s_d_va.*vec;
            end

            if ~isempty(obj.y_y_siemens)
                obj.y_y_siemens = obj.y_y_siemens.*vec;
            end
            if ~isempty(obj.y_d_siemens)
                obj.y_d_siemens = obj.y_d_siemens.*vec;
            end

            if ~isempty(obj.i_y_a)
                obj.i_y_a = obj.i_y_a.*vec;
            end
            if ~isempty(obj.i_d_a)
                obj.i_d_a = obj.i_d_a.*vec;
            end

            if ~isempty(obj.y_y_va)
                obj.y_y_va = obj.y_y_va.*vec;
            end
            if ~isempty(obj.y_d_va)
                obj.y_d_va = obj.y_d_va.*vec;
            end

            if ~isempty(obj.i_y_va)
                obj.i_y_va = obj.i_y_va.*vec;
            end
            if ~isempty(obj.i_d_va)
                obj.i_d_va = obj.i_d_va.*vec;
            end
        end
    end


    properties
        % Elementary loads
        % s_y_va is defined in uot.AbstractLoadSpec

        s_d_va(:,:) double % delta-connected constant power load in VA
        y_y_siemens(:,:) double % wye-connected constant admittance load in siemens
        y_d_siemens(:,:) double % delta-connected constant admittance load in siemens
        i_y_a(:,:) double % wye-connected constant current load in A
        i_d_a(:,:) double % delta-connected constant current load in A

        % Derived loads

        y_y_va(:,:) double % wye-connected constant admittance load in VA
        y_d_va(:,:) double % delta-connected constant admittance load in VA
        i_y_va(:,:) double % wye-connected constant current load in VA
        i_d_va(:,:) double % delta-connected constant current load in VA
    end
end