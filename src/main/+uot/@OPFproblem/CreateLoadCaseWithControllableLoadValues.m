function load_case = CreateLoadCaseWithControllableLoadValues(obj)
load_case_spec_new = obj.load_case.spec;
load_case_spec_new.load_spec_array = obj.CreateLoadSpecArrayWithControllableLoadValues();

load_case = uot.LoadCasePy(load_case_spec_new,obj.network);
end