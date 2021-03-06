function opf_problem = GetExampleOPFproblem(pf_surrogate_spec,use_gridlab)
% Here we create a charger maximization problem where we want to maximize the
% power delivered to the chargers subject to constraints on voltage mangitude
% and substation transformer capacity.

if use_gridlab
    % Import model from Gridlabd
    model_importer = GetModelImporterIEEE_13_NoRegs();
    model_importer.Initialize();
    load_case_zip = model_importer.load_case;
    u_pcc_array = model_importer.u_pcc_array;
    t_pcc_array = model_importer.t_pcc_array;
else
    % Use model in native format
    load_case_zip = GetLoadCaseIEEE_13_NoRegs_Manual();
    % Reference voltage from spec (we do not model the regulator)
    u_pcc_array = [1.0625, 1.0500, 1.0687];
    t_pcc_array = deg2rad([0, -120, 120]);
end

% Convert all loads to constrant power wye-connected
load_case = load_case_zip.ConvertToLoadCasePy();

% Specify controllable loads
controllable_load_spec_array = [...
    uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1],'p_min_va',0,'q_min_va',0,'q_max_va',0);
    uot.ControllableLoadSpec('charger_675_9','l675',[1,1,1],'p_min_va',0,'q_min_va',0,'q_max_va',0);
    uot.ControllableLoadSpec('charger_611_12','l611',[0,0,1],'p_min_va',0,'q_min_va',0,'q_max_va',0);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'p_min_va',0,'q_min_va',0,'q_max_va',0);
    ];

% Specify cost of controllable loads to maximize power delivered to them.
load_cost_spec_array = [...
    uot.LoadCostSpec('charger_632_2','cost_p',-1);
    uot.LoadCostSpec('charger_675_9','cost_p',-1);
    uot.LoadCostSpec('charger_611_12','cost_p',-1);
    uot.LoadCostSpec('charger_652_13','cost_p',-1);
    ];

objective_spec = uot.OPFobjectiveSpec_LoadCost(load_cost_spec_array);

% Specify voltage magnitude constraint: up to 5% deviation from nominal voltage
voltage_magnitude_spec = uot.VoltageMaginitudeSpec(0.95,1.05);

% Specify reference voltage
pcc_voltage_spec = uot.PCCvoltageSpec(u_pcc_array,t_pcc_array);

% Specify constraint on substation transformer rating (5 MVA according to spec)
pcc_load_spec = uot.PCCloadSpec('p_min_va',0,'s_sum_mag_max_va',5e6);

% Pack everything into OPFspec
opf_spec = uot.OPFspec(pf_surrogate_spec,controllable_load_spec_array,objective_spec,pcc_voltage_spec,...
    voltage_magnitude_spec,'pcc_load_spec',pcc_load_spec);

% Instantiate OPFproblem
opf_problem = uot.OPFproblem(opf_spec,load_case);
end