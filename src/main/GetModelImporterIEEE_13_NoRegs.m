function model_importer = GetModelImporterIEEE_13_NoRegs()
model_importer_spec = uot.ModelImporterSpec_Gridlabd([GetPathToUOT(),'third_party/gridlab-d-networks/IEEE_13_NoRegs'],'IEEE_13_NoRegs.glm');

model_importer = uot.ModelImporter_Gridlabd(model_importer_spec);
end