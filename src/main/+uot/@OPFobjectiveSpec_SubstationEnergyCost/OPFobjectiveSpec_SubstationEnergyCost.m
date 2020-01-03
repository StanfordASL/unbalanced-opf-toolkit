classdef OPFobjectiveSpec_SubstationEnergyCost < uot.ObjectiveSpec
    methods
        function obj = OPFobjectiveSpec_SubstationEnergyCost(substation_energy_cost_usd_per_j)
            obj.substation_energy_cost_usd_per_j = substation_energy_cost_usd_per_j;
        end
    end

    properties
        substation_energy_cost_usd_per_j(1,:) double {mustBeReal};
    end
end