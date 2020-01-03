classdef ModelImporter_Gridlabd < uot.ModelImporter

    methods
        function obj = ModelImporter_Gridlabd(spec)
            uot.AssertIsInstance(spec,'uot.ModelImporterSpec_Gridlabd')
            obj@uot.ModelImporter(spec)
        end

        Initialize(obj);
        Validate(obj);
    end

    properties
        validate(1,1) logical = true % flag to validate data after importing them
        validate_tol(1,1) double {mustBePositive} = 1e-6
    end

    properties (SetAccess = private, GetAccess = public)
        % Output
        network


        % See ParseLoadData for why we import non- and pre-rotated load cases
        load_case % non-pre-rotated load_case
        load_case_prerot % pre-rotated load_case

        u_pcc_array
        t_pcc_array

        % The following are meant for validating against Gridlabd

        U_ref_array
        U_ref_array_v
        T_ref_array

        p_pcc_ref_array
        p_pcc_ref_array_va
        q_pcc_ref_array
        q_pcc_ref_array_va

        I_link_from_ref_array
        I_link_from_ref_array_a
        I_link_to_ref_array
        I_link_to_ref_array_a
    end

    methods (Static)
        CreateGridlabdTimeZoneMap()
        gld_time_zone = GetGridlabdTimeZone(t)
    end

    methods (Access = private)
        CleanGridlabdDirectory(obj)
        CreateOPFdataFile(obj)
        bus_spec_array = ParseBusData(obj)
        [I_link_from_ref_array,I_link_to_ref_array,I_link_from_ref_array_a,I_link_to_ref_array_a] = ParseLinkCurrentData(obj)
        link_spec_array =  ParseLinkData(obj)
        [load_case,load_case_prerot] = ParseLoadData(obj)
        [p_pcc_ref_array,q_pcc_ref_array,p_pcc_ref_array_va,q_pcc_ref_array_va] = ParsePCCloadData(obj)
        [V_ref_array,V_ref_array_v] = ParseVoltageData(obj)
        status = RunGridlabd(obj)
        ValidateTimeStampArray(obj,time_stamp_array)
    end

    methods (Static, Access = private)
        [time_stamp_array,data_table_cell] = ParseTimeSeriesData(file_name)
    end

end