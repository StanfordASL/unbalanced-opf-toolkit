function [opf_problem,model_importer] = GetOPFproblem_ChargerMaximization_IEEE_13_NoRegs_Schedule()
path_to_uot = GetPathToUOT();
model_importer_spec = uot.ModelImporterSpec_Gridlabd([path_to_uot,'third_party/gridlab-d-networks/IEEE_13_NoRegs_Schedule'],'IEEE_13_NoRegs_Schedule.glm');

model_importer_spec.time_step_s = 600;
model_importer_spec.n_time_step = 5;

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);

model_importer.Initialize();

load_case = model_importer.load_case.ConvertToLoadCasePy();

pf_surrogate_spec = uot.PowerFlowSurrogateSpec_Gan2014_SDP();

controllable_load_spec_array = [...
    uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1],'p_min_va',0,'q_min_va',0,'q_max_va',0);
    uot.ControllableLoadSpec('charger_675_9','l675',[1,1,1],'p_min_va',0,'q_min_va',0,'q_max_va',0);
    uot.ControllableLoadSpec('charger_611_12','l611',[0,0,1],'p_min_va',0,'q_min_va',0,'q_max_va',0);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'p_min_va',0,'q_min_va',0,'q_max_va',0);
    ];

load_cost_spec_array = [...
    uot.LoadCostSpec('charger_632_2','cost_p',-1);
    uot.LoadCostSpec('charger_675_9','cost_p',-1);
    uot.LoadCostSpec('charger_611_12','cost_p',-1);
    uot.LoadCostSpec('charger_652_13','cost_p',-1);
    ];

objective_spec = uot.OPFobjectiveSpec_LoadCost(load_cost_spec_array);

voltage_magnitude_spec = uot.VoltageMaginitudeSpec(0.95,1.05);

pcc_voltage_spec = uot.PCCvoltageSpec(model_importer.u_pcc_array,model_importer.t_pcc_array);

pcc_load_spec = uot.PCCloadSpec('p_min_va',0,'s_sum_mag_max_va',5e6);

opf_spec = uot.OPFspec(pf_surrogate_spec,controllable_load_spec_array,objective_spec,pcc_voltage_spec,...
    voltage_magnitude_spec,'pcc_load_spec',pcc_load_spec);

opf_problem = uot.OPFproblem(opf_spec,load_case);
end