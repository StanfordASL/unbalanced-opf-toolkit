function decision_variables_val = EvaluateDecisionVariables(obj)
for field_c = fields(obj.decision_variables).'
    field = field_c{:};

    decision_variable = obj.decision_variables.(field);

    switch class(decision_variable)
        case 'sdpvar'
            decision_variable_value = value(decision_variable);

        case 'double'
            decision_variable_value = decision_variable;

        case 'cell'

            n_decision_variable = numel(decision_variable);

            decision_variable_value = cell(size(decision_variable));

            for i_decision_variable = 1:n_decision_variable
                decision_variable_value{i_decision_variable} = ...
                    value(decision_variable{i_decision_variable});
            end

        otherwise
            error('Unexpected class %s for decision_variable',class(decision_variable));
    end

    decision_variables_val.(field) = decision_variable_value;
end
end