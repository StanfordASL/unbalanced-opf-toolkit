classdef ModelImporterSpec_Gridlabd < uot.ModelImporterSpec
    % ModelImporterSpec_Gridlabd specifies an object to import data from
    % Gridlabd
    methods
        function obj = ModelImporterSpec_Gridlabd(directory_gld_model,file_name_gld_model)
            obj.directory_gld_model = directory_gld_model;
            obj.file_name_gld_model = file_name_gld_model;
        end

        function directory_uot_output_full = get.directory_uot_output_full(obj)
            directory_uot_output_full = [obj.directory_gld_model,'/',obj.directory_uot_output];
        end

        function res = get.end_date_time(obj)
            duration_s = obj.n_time_step*obj.time_step_s;

            % -1 because start and end are inclusive in gridlab
            res = obj.start_date_time + seconds(duration_s - 1);
        end

        function res = PrependUOToutputDirFull(obj,file_name)
            res = [obj.directory_uot_output_full,'/',file_name];
        end

        function res = PrependGLDmodelDir(obj,file_name)
            res = [obj.directory_gld_model,'/',file_name];
        end
    end

    properties
        start_date_time(1,1) datetime = datetime('01-Jan-2010 00:00:00','TimeZone','America/Los_Angeles') % datetime when Gridlabd's simulation starts. If not time-zone is specified, we ues the one in file_name_gld_model.

        admittance_change_output(1,1) uot.enum.AdmittanceChangeOutput = ...
            uot.enum.AdmittanceChangeOutput.ERROR % Gridlabd's behavior when an admittance change is detected

        directory_gld_model(1,:) char % name of the directory with the Gridlabd model
        file_name_gld_model(1,:) char % file name of the Gridlabd model

        directory_uot_output(1,:) char = 'uot_output' % name of the directory for outputting data from Gridlabd
        file_name_opf_data(1,:) char = 'uot_data.glm' % name of the file the interface creates to control Gridlabd
        file_name_bus_data(1,:) char = 'bus_data' % name of the file where Gridlab writes bus data
        file_name_load_data(1,:) char = 'load_data' % name of the file where Gridlab writes load data
        file_name_link_data(1,:) char = 'link_data' % name of the file where Gridlab writes link data
        file_name_link_current_data(1,:) char = 'link_current_data' % name of the file where Gridlab writes link current data
        file_name_pcc_load_data(1,:) char = 'pcc_load_data' % name of the file where Gridlab writes pcc_load data
        file_name_voltage_data(1,:) char = 'voltage_data' % name of the file where Gridlab writes voltage data

        reset_u_nom_v_on_splitphased_buses(1,1) logical = true % flag to set u_nom_v in split phased buses to 120 V. In some Gridlabd models split phased (triplex) buses have incorrect nominal voltages and this leads to errors.
    end

    properties (Dependent)
        directory_uot_output_full
        end_date_time
    end
end