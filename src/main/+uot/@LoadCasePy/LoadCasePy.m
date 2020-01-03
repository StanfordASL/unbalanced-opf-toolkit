classdef LoadCasePy < uot.AbstractLoadCase
    methods
        function obj = LoadCasePy(spec,network)
            % LoadCasePy Constructs a LoadCasePy object
            %   LoadCasePy(network,spec) instantiates LoadCasePy with
            %   loads from the spec.

            validateattributes(spec,{'uot.LoadCasePySpec'},{});
            obj@uot.AbstractLoadCase(spec,network);
        end
    end

     % Implemented abstract methods
    methods (Access = protected)
        [I_inj_stack,I_n] = ComputeCurrentInjectionHelper(obj,V_s,V_n)
    end
end