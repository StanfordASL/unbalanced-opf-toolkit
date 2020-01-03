classdef (Abstract) ConstraintProvider < uot.Object
    % Interface to define building blocks of optimization problems, they are not necessarily solvable.
    %
    % Synopsis::
    %
    %   obj = uot.ConstraintProvider(spec,decision_variables)
    %
    % Arguments:
    %   spec (|uot.Spec|): Object specification
    %   decision_variables (struct): Struct with decision variables (as sdpvars)


    methods
        function obj = ConstraintProvider(spec,decision_variables)
            obj@uot.Object(spec)
            obj.decision_variables = decision_variables;
        end

        decision_variables_val = EvaluateDecisionVariables(obj)
    end

    properties
        constraint_tol(1,1) {mustBePositive} = 1e-6 % Tolerance for AssertConstraintSatisfaction
    end

    methods (Abstract)
        % This method is intended for debugging. It shall assert that the
        % results of the optimization fulfill the provided constraints.
        % This should not be verified by acting directly on the YALMIP constraints,
        % instead, other methods shall be used.
        AssertConstraintSatisfaction(obj)

        constraint_array = GetConstraintArray(obj)
    end

    properties (Access = protected)
        decision_variables % Struct with sdpvars
    end
end