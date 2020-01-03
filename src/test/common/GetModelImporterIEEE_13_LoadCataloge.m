function model_importer = GetModelImporterIEEE_13_LoadCataloge()
path_to_uot = GetPathToUOT();
model_importer_spec = uot.ModelImporterSpec_Gridlabd([path_to_uot,'third_party/gridlab-d-networks/IEEE_13_LoadCatalogue'],'IEEE_13_LoadCatalogue.glm');

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end