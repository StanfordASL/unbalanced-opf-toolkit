function model_importer = GetModelImporterTaxonomy_R1_4()
path_to_uot = GetPathToUOT();
model_importer_spec = uot.ModelImporterSpec_Gridlabd([path_to_uot,'third_party/gridlab-d-networks/R1-12.47-4'],'R1-12.47-4.glm');

% The loads do not change across time. This is for testing purposes.
model_importer_spec.n_time_step = 3;
model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end