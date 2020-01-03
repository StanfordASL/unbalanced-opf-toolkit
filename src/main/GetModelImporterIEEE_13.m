function model_importer = GetModelImporterIEEE_13()
model_importer_spec = uot.ModelImporterSpec_Gridlabd([GetPathToUOT(),'third_party/gridlab-d-networks/IEEE_13'],'IEEE_13.glm');

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end