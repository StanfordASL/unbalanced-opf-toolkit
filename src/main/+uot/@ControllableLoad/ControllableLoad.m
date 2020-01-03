classdef ControllableLoad < uot.ConstraintProvider

    methods
        function obj = ControllableLoad(spec,opf_problem)

            validateattributes(spec,{'uot.ControllableLoadSpec'},{'scalar'},mfilename,'spec',1);

            decision_variables = uot.ControllableLoad.DefineDecisionVariables(spec,opf_problem);
            obj@uot.ConstraintProvider(spec,decision_variables);

            obj.opf_problem = opf_problem;
        end

        AssertConstraintSatisfaction(obj)
        load_py_spec = CreateLoadPySpecWithCurrentValue(obj)
        ValidateSpec(obj)

        function AssignNoLoad(obj)
            obj.AssignValue(0,0);
        end

        function AssignValue(obj,p_val,q_val)
            assign(obj.decision_variables.p,p_val)
            assign(obj.decision_variables.q,q_val);
        end

        function [p_val,q_val] = GetValue(obj)
            p_val = value(obj.decision_variables.p);
            q_val = value(obj.decision_variables.q);
        end

        function [n_row,n_col] = GetSsize(obj)
            % Returns the number of rows and columns in p and q

            n_time_step = obj.opf_problem.n_time_step;
            n_row = n_time_step;
            n_col = obj.spec.n_phase;
        end

        function p = get.p(obj)
            p = obj.decision_variables.p;
        end

        function q = get.q(obj)
            q = obj.decision_variables.q;
        end

        % Implemented methods from uot.ConstraintProvider
        constraint_array = GetConstraintArray(obj)
    end

    properties (Dependent, Access = {?uot.OPFproblem})
        p
        q
    end

    properties (Access = private)
        opf_problem
    end

    methods (Static,Access = private)
        function decision_variables = DefineDecisionVariables(spec,opf_problem)
            n_time_step = opf_problem.n_time_step;

            decision_variables.p = sdpvar(n_time_step,spec.n_phase);
            decision_variables.q = sdpvar(n_time_step,spec.n_phase);
        end
    end



end