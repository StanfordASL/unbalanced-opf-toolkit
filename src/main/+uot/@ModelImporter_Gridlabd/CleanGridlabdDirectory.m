function CleanGridlabdDirectory(obj)
    % CleanGLDdirectory deletes all files in obj.directory_gld_model other than obj.file_name_gld_model
    files_in_dir_struct = dir(obj.spec.directory_uot_output_full);

    n_files_in_dir = numel(files_in_dir_struct);

    %Start at 3 to ignore . and ..
    for i_files_in_dir = 3:n_files_in_dir
        filename = files_in_dir_struct(i_files_in_dir).name;
        [~,~,ext] = fileparts(filename);
        if ~strcmp(ext,'.glm')
            delete([obj.spec.directory_uot_output_full,'/',filename]);
        end
    end
end