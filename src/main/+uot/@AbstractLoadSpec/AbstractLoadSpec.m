classdef (Abstract) AbstractLoadSpec < uot.Spec
    % uot.AbstractLoadSpec Class with common functionality to specify loads
    methods
        function obj = AbstractLoadSpec(bus)
            obj.bus = bus;
        end

        function obj = times(obj,vec)
            % Scales the loads by multiplying them with a vector vec.
            % If n_time_spec == 1 and vec has more than 1 elements, the new
            % load case will have n_time_spec = numel(vec)
            % If n_time_spec ~= 1, then vec must have either 1 or n_time_spec elements

            validateattributes(vec,{'double'},{'vector'},mfilename,'vec',2);

            % Ensure vec is a row vector so that it coincides with time dimension
            vec = vec(:);

            if ~isempty(obj.s_y_va)
                % Note that Matlab automatically expands vec
                obj.s_y_va = obj.s_y_va.*vec;
            end
        end
    end

    properties
        bus(1,:) char % bus to which load is attached

        % Elementary loads
        s_y_va(:,:) double % wye-connected constant power load in VA
    end
end