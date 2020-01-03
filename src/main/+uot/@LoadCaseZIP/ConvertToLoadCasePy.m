function load_case_py = ConvertToLoadCasePy(obj,varargin)
% ConvertToLoadCasePy(obj) % Use flat voltage
% ConvertToLoadCasePy(obj,U_array,T_array) % Use U_array and T_array

n_varagin = numel(varargin);

if n_varagin == 0
    v_flat = obj.network.GetFlatVoltage();

    V = ReplicateToAllBuses(obj.network,v_flat);

    V_array = repmat(V,1,1,obj.spec.n_time_step);

    [U_array,T_array] = uot.ComplexToPolar(V_array);

elseif n_varagin == 2
    U_array = varargin{1};
    T_array = varargin{2};

    uot.AssertPhaseConsistency(U_array,obj.network.bus_has_phase);
    uot.AssertPhaseConsistency(T_array,obj.network.bus_has_phase);
end

[P_inj_array,Q_inj_array] = obj.ComputePowerInjection(U_array,T_array);

n_bus = obj.network.n_bus;

% Start at i_bus = 2 to neglect pcc
i_load_spec_cell = 0;
load_spec_cell = cell(n_bus,1);

for i_bus = 2:n_bus
    s_inj_bus = P_inj_array(i_bus,:,:) + 1i*Q_inj_array(i_bus,:,:);
    s_inj_bus_va = s_inj_bus*obj.network.spec.s_base_va;

    if any(s_inj_bus_va(:) ~= 0)
        % Recall that loads are negative power injections
        s_y_pre_va = -s_inj_bus_va;

        % Set missing phases to zero according to requirements of LoadPySpec
        phase = obj.network.bus_has_phase(i_bus,:);
        s_y_pre_va(:,~phase,:) = 0;

        % Permute to shift time dimension from 3 to 1
        s_y_va = permute(s_y_pre_va,[3,2,1]);

        bus_name = obj.network.bus_data_array(i_bus).name;

        i_load_spec_cell = i_load_spec_cell + 1;
        load_spec_cell{i_load_spec_cell} = uot.LoadPySpec(bus_name,s_y_va);
    end
end

load_spec_array = vertcat(load_spec_cell{1:i_load_spec_cell});

time_step_s = obj.spec.time_step_s;
n_time_step = obj.spec.n_time_step;

load_case_py_spec = uot.LoadCasePySpec(load_spec_array,time_step_s,n_time_step);
load_case_py_spec.start_date_time = obj.spec.start_date_time;

load_case_py = uot.LoadCasePy(load_case_py_spec,obj.network);
end

function X = ReplicateToAllBuses(network,x_pcc)
uot.AssertPhaseConsistency(x_pcc,network.bus_has_phase(1,:));

x_pcc = x_pcc(:).';

X_pre = repmat(x_pcc(network.bus_has_phase(1,:)),network.n_bus,1);

X = uot.ExtractPhaseConsistentValues(X_pre,network.bus_has_phase);
end