% Objectives are specified in classes derived from OPFobjectiveSpec.
% Here, we implement objectives that are independent of the power flow surrogate
% because they operate only on power variables.
% Objectives that operate on voltages and currents whose representation
% depends on the power flow surrogate used need to be implemented for the
% particular surrogate by implementing uot.AbstractPowerFlowSurrogate.DefineObjective
function objective = GetObjective(obj)
    objective_spec = obj.spec.objective_spec;

    switch class(objective_spec)
        case 'uot.OPFobjectiveSpec_LoadCost'
            objective = obj.DefineObjective_LoadCost(objective_spec);

        case 'uot.OPFobjectiveSpec_SubstationEnergyCost'
            objective = obj.DefineObjective_SubstationEnergyCost(objective_spec);

        otherwise
            % Request the objective from the surrogate
            objective = obj.pf_surrogate.DefineObjective(objective_spec);
    end
end