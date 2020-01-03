function model_importer = GetModelImporterIEEE_13_NoRegs_Schedule()
path_to_uot = GetPathToUOT();
model_importer_spec = uot.ModelImporterSpec_Gridlabd([path_to_uot,'third_party/gridlab-d-networks/IEEE_13_NoRegs_Schedule'],'IEEE_13_NoRegs_Schedule.glm');

model_importer_spec.time_step_s = 600;
model_importer_spec.n_time_step = 5;

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end