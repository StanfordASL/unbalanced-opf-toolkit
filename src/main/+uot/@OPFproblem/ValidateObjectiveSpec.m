function ValidateObjectiveSpec(obj)
objective_spec = obj.spec.objective_spec;
switch class(objective_spec)
    case 'uot.OPFobjectiveSpec_LoadCost'
        obj.ValidateObjectiveSpec_LoadCost();

    case 'uot.OPFobjectiveSpec_SubstationEnergyCost'
        obj.ValidateObjectiveSpec_SubstationEnergyCost();

    otherwise
        error('ValidateObjectiveSpec not implemented for class %s',class(objective_spec))
end
end
