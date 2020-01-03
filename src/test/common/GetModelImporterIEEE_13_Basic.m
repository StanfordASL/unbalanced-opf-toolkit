function model_importer = GetModelImporterIEEE_13_Basic()
path_to_uot = GetPathToUOT();
model_importer_spec = uot.ModelImporterSpec_Gridlabd([path_to_uot,'third_party/gridlab-d-networks/IEEE_13_Basic'],'IEEE_13_Basic.glm');

model_importer_spec.time_step_s = 1;
model_importer_spec.n_time_step = 1;

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end