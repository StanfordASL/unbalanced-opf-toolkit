function model_importer_array = GetModelImporterCatalogue()
% Returns an array of available models for testing purposes

model_importer_array = [
    % Basic models
    GetModelImporterIEEE_13_NoRegs();
    GetModelImporterIEEE_13();
    GetModelImporterIEEE_13_LoadCataloge();
    GetModelImporterIEEE_123();
    %
    % Models with time-series loads
    GetModelImporterIEEE_13_NoRegs_Schedule();
    GetModelImporterHL0004();
    GetModelImporterPL0001();
    %
    % Models with split-phases
    GetModelImporterSPCT_TriplexLoad();
    GetModelImporterSPCT_TriplexLoad120();
    GetModelImporterSPCT_TriplexLoad2400();
    GetModelImporterSPCT_TriplexLoadCurrent();
    GetModelImporterTaxonomy_R1_4();
    GetModelImporterTaxonomy_R3_3();
    GetModelImporterTaxonomy_R5_5();
    ];
end