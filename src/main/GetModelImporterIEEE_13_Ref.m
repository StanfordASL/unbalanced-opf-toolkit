function model_importer = GetModelImporterIEEE_13_Ref()
model_importer_spec = uot.ModelImporterSpec_Gridlabd([GetPathToUOT(),'third_party/gridlab-d-networks/IEEE_13_Ref'],'IEEE_13_Ref.glm');

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end