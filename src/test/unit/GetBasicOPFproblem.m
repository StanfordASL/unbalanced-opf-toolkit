function opf_problem = GetBasicOPFproblem()
model_importer = GetModelImporterIEEE_13_NoRegs_Schedule();
model_importer.Initialize();

load_case = model_importer.load_case.ConvertToLoadCasePy();

pf_surrogate_spec = uot.PowerFlowSurrogateSpec_Gan2014_SDP();

controllable_load_spec = uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1]);

objective_spec = uot.OPFobjectiveSpec_LoadCost(uot.LoadCostSpec('charger_632_2','cost_p',-1));

voltage_magnitude_spec = uot.VoltageMaginitudeSpec(0.95,1.05);

pcc_voltage_spec = uot.PCCvoltageSpec(model_importer.u_pcc_array,model_importer.t_pcc_array);

opf_spec = uot.OPFspec(pf_surrogate_spec,controllable_load_spec,objective_spec,pcc_voltage_spec,...
    voltage_magnitude_spec);

opf_problem = uot.OPFproblem(opf_spec,load_case);
end