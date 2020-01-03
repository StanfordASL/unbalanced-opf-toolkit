function load_py_spec = CreateLoadPySpecWithCurrentValue(obj)
s_base_va = obj.opf_problem.load_case.network.spec.s_base_va;

[p_val,q_val] = obj.GetValue();

s_val = p_val + 1i*q_val;

s_y_pre_va = s_val*s_base_va;

phase = obj.spec.phase;

n_time_step = obj.opf_problem.n_time_step;
n_phase = obj.opf_problem.network.n_phase;

s_y_va = zeros(n_time_step,n_phase);
s_y_va(:,phase) = s_y_pre_va;

attachment_bus = obj.spec.attachment_bus;
load_py_spec = uot.LoadPySpec(attachment_bus,s_y_va);
end