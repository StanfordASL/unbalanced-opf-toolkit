function load_case_new = CreateLoadCaseIncludingControllableLoadValues(obj)
load_case_spec_new = obj.load_case.spec;

load_spec_from_controllable_loads_array = obj.CreateLoadSpecArrayWithControllableLoadValues();

load_case_spec_new.load_spec_array = [
        load_case_spec_new.load_spec_array;
        load_spec_from_controllable_loads_array
    ];

load_case_new = uot.LoadCasePy(load_case_spec_new,obj.network);
end