classdef (Abstract) Object < handle
    % Object Fundamental class that takes a spec as constructor
    % UOT is built around Spec and Object.

    methods
        function obj = Object(spec)
            % Constructs an UOT Object
            % obj = Object(spec) takes spec and instantiates the specified
            % object. The derived class must check that spec has the right
            % type. Here, we only check that spec is an uot.Spec.
            validateattributes(spec,{'uot.Spec'},{'scalar'})
            obj.spec = spec;
        end

        function ValidateSpec(obj)
            % ValidateSpec Throws an error if the spec is not consistent
            %   uot.Spec typically does not include much error checking
            %   since consistency typically depends on other objects (e.g.,
            %   the power network).
            %   This function is can be overriden to do error checking
            %   once more context is known.
        end
    end


    properties (GetAccess = public, SetAccess = immutable)
        spec
    end

    properties
        verbose(1,1) logical = false;
    end
end