function [opf_problem,model_importer] = GetOPFproblem_ChargerMaximization_PL_1_peak()
path_to_uot = GetPathToUOT();
model_importer_spec = uot.ModelImporterSpec_Gridlabd([path_to_uot,'third_party/gridlab-d-networks/PL0001'],'PL0001_glmfile_ts.glm');

model_importer_spec.start_date_time = datetime('01-Jun-2017 21:00:00');
% Loads in the model change every 30 min
model_importer_spec.time_step_s = 1800;
% Consider 24 hour
model_importer_spec.n_time_step = 1;

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);

model_importer.Initialize()

load_case = model_importer.load_case.ConvertToLoadCasePy();

pf_surrogate_spec = uot.PowerFlowSurrogateSpec_Gan2014_SDP();

controllable_load_spec_array = [...
	uot.ControllableLoadSpec('charger_1','N_300063908',[1 1 1],'p_min_va',0,'p_max_va',4.554869e+05,'q_min_va',0,'q_max_va',0);
	uot.ControllableLoadSpec('charger_2','N_300231597',[1 1 1],'p_min_va',0,'p_max_va',4.554869e+05,'q_min_va',0,'q_max_va',0);
    ];

load_cost_spec_array = [...
	uot.LoadCostSpec('charger_1','cost_p',-1);
	uot.LoadCostSpec('charger_2','cost_p',-1);
	];

objective_spec = uot.OPFobjectiveSpec_LoadCost(load_cost_spec_array);

voltage_magnitude_spec = uot.VoltageMaginitudeSpec(0.95,1.05);

pcc_voltage_spec = uot.PCCvoltageSpec(model_importer.u_pcc_array,model_importer.t_pcc_array);

pcc_load_spec = uot.PCCloadSpec('p_min_va',0,'s_sum_mag_max_va',9.760435e+06);

opf_spec = uot.OPFspec(pf_surrogate_spec,controllable_load_spec_array,objective_spec,pcc_voltage_spec,...
    voltage_magnitude_spec,'pcc_load_spec',pcc_load_spec);

opf_problem = uot.OPFproblem(opf_spec,load_case);
end