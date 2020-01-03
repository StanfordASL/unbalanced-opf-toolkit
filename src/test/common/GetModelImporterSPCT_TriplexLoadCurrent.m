function model_importer = GetModelImporterSPCT_TriplexLoadCurrent()
path_to_uot = GetPathToUOT();
model_importer_spec = uot.ModelImporterSpec_Gridlabd([path_to_uot,'third_party/gridlab-d-networks/SPCT_TriplexLoadCurrent'],'SPCT_TriplexLoadCurrent.glm');

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end