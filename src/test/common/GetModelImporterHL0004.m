function model_importer = GetModelImporterHL0004
model_importer_spec = uot.ModelImporterSpec_Gridlabd([GetPathToUOT(),'third_party/gridlab-d-networks/HL0004'],'HL0004_glmfile_ts.glm');

model_importer_spec.time_step_s = 3600;
model_importer_spec.n_time_step = 5;

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end