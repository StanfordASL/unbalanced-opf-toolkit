classdef (Abstract) Problem < uot.ConstraintProvider
    % uot.Problem Class with common functionality for optimization problems that can be solved

    methods
        function obj = Problem(spec,decision_variables)
            % Problem Instantiates a Problem
            % obj = Problem(spec) takes spec and instantiates the specified
            % object. The derived class must check that spec has the right
            % type. Here, we only check that spec is an uot.ProblemSpec.

            validateattributes(spec,{'uot.ProblemSpec'},{'scalar'},mfilename,'spec',1)

            obj@uot.ConstraintProvider(spec,decision_variables);
        end

        function [objective_value,solver_time,diagnostics] = Solve(obj)
            % Solve Solves the optimization problem

            constraint_array = obj.GetConstraintArray();
            objective = obj.GetObjective();

            diagnostics = optimize(constraint_array,objective,obj.sdpsettings);

            if diagnostics.problem ~= 0
                warning('Solver experienced issues: %s',diagnostics.info);
            end

            objective_value = value(objective);

            solver_time = diagnostics.solvertime;

            obj.is_solved = true;
        end
    end

    properties
        % sedumi is a free SDP solver which works well for small to medium sized problems.
        sdpsettings(1,1) = sdpsettings('solver','sedumi') % Struct with YALMIP settings
    end

    properties (SetAccess = private, GetAccess = public)
       is_solved(1,1) logical = false
    end

    % These methods must be implemented by the derived classes
    methods (Abstract, Access = protected)
        objective = GetObjective(obj)
    end
end