classdef (Abstract) Spec
    % Spec Fundamental class that takes a spec as constructor.
    % The idea is that spec can be freely changed by itself. When it is
    % used to instantiate an object, the object saves a copy which cannot
    % be changed anymore. Instead, one can change the spec and instantiate
    % object again.
    %
    % UOT is built around Spec and Object.


    methods
        function obj = Spec()
            % Constructs an UOT Spec
        end
    end
end

