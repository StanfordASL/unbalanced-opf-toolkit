function CreateOPFdataFile(obj)
% Creates a file with specifying Gridlab's output in a suitable format for UOT
file_id = uot.FopenWrapper([obj.spec.directory_gld_model,'/',obj.spec.file_name_opf_data],'w');

fprintf(file_id,'// Override time settings\n');

start_date_time = obj.spec.start_date_time;
gld_time_zone_str = uot.ModelImporter_Gridlabd.GetGridlabdTimeZone(start_date_time);

fprintf(file_id,'clock {\n');
% uot.ModelImporter_Gridlabd.GetGridlabdTimeZone returns an empty string if it fails to convert the time zone in start_date_time
% to Gridlabd's format. In this case, we do not add the time zone command  and Gridlabd uses the one specified in the glm model file.
if ~isempty(gld_time_zone_str)
    fprintf(file_id,'\ttimezone %s;\n',gld_time_zone_str);
end

start_date_time_str = datestr(obj.spec.start_date_time,'yyyy-mm-dd HH:MM:SS');
fprintf(file_id,'\tstarttime ''%s'';\n',start_date_time_str);

end_date_time_str = datestr(obj.spec.end_date_time,'yyyy-mm-dd HH:MM:SS');
fprintf(file_id,'\tstoptime ''%s'';\n',end_date_time_str);
fprintf(file_id,'}\n\n');

fprintf(file_id,'object uot_network_exporter {\n');
fprintf(file_id,'\tfile_name_node_data %s;\n',[obj.spec.directory_uot_output,'/',obj.spec.file_name_bus_data]);
fprintf(file_id,'\tfile_name_branch_data %s;\n',[obj.spec.directory_uot_output,'/',obj.spec.file_name_link_data]);
fprintf(file_id,'\tadmittance_change_output %s;\n',char(obj.spec.admittance_change_output));
fprintf(file_id,'}\n\n');

fprintf(file_id,'object uot_state_exporter {\n');
fprintf(file_id,'\tinterval %d;\n',obj.spec.time_step_s);
fprintf(file_id,'\tfile_name_load_data %s;\n',[obj.spec.directory_uot_output,'/',obj.spec.file_name_load_data]);
fprintf(file_id,'\tfile_name_voltage_data %s;\n',[obj.spec.directory_uot_output,'/',obj.spec.file_name_voltage_data]);
fprintf(file_id,'\tfile_name_current_data %s;\n',[obj.spec.directory_uot_output,'/',obj.spec.file_name_link_current_data]);
fprintf(file_id,'\tfile_name_swing_load_data %s;\n',[obj.spec.directory_uot_output,'/',obj.spec.file_name_pcc_load_data]);
fprintf(file_id,'}');

fclose(file_id);
end