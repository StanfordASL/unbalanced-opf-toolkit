function model_importer = GetModelImporterTaxonomy_R5_5()
path_to_uot = GetPathToUOT();
model_importer_spec = uot.ModelImporterSpec_Gridlabd([path_to_uot,'third_party/gridlab-d-networks/R5-12.47-5'],'R5-12.47-5.glm');

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end