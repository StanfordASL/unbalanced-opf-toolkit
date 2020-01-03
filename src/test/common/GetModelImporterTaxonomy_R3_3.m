function model_importer = GetModelImporterTaxonomy_R3_3()
path_to_uot = GetPathToUOT();
model_importer_spec = uot.ModelImporterSpec_Gridlabd([path_to_uot,'third_party/gridlab-d-networks/R3-12.47-3'],'R3-12.47-3.glm');

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end