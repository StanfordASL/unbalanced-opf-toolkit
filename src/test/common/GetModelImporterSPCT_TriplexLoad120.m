function model_importer = GetModelImporterSPCT_TriplexLoad120()
path_to_uot = GetPathToUOT();
model_importer_spec = uot.ModelImporterSpec_Gridlabd([path_to_uot,'third_party/gridlab-d-networks/SPCT_TriplexLoad120'],'SPCT_TriplexLoad120.glm');

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end