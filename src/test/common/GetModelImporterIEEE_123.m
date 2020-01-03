function model_importer = GetModelImporterIEEE_123()
model_importer_spec = uot.ModelImporterSpec_Gridlabd([GetPathToUOT(),'third_party/gridlab-d-networks/IEEE_123'],'IEEE_123.glm');

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end