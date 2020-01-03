function status = RunGridlabd(obj)
% Executes Gridlabd on file_name_gld_model

current_dir = pwd;

%Run gridlabd
cd(obj.spec.directory_gld_model);
command = ['gridlabd ',obj.spec.file_name_gld_model];

[status,status_msg] = system(command);

cd(current_dir)

if obj.verbose || status ~= 0
    disp(status_msg)

    if status ~= 0
        error('Error running gridlab.');
    end
end
end
