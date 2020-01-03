function model_importer = GetModelImporterPL0001
model_importer_spec = uot.ModelImporterSpec_Gridlabd([GetPathToUOT(),'third_party/gridlab-d-networks/PL0001'],'PL0001_glmfile_ts.glm');

model_importer_spec.time_step_s = 3600;
model_importer_spec.n_time_step = 5;

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);

end