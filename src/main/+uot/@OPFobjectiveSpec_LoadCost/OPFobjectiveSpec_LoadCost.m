classdef OPFobjectiveSpec_LoadCost < uot.ObjectiveSpec
    methods
        function obj = OPFobjectiveSpec_LoadCost(load_cost_spec_array)
            obj.load_cost_spec_array = load_cost_spec_array;
        end

    end

    properties
        load_cost_spec_array(1,:) uot.LoadCostSpec;
    end
end