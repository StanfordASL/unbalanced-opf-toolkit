function PublishFilesToRST(source_file_path_cell, destination_path)
% Publish .m files to rst.
% Arguments:
%   source_file_path_cell (cell): Cell array with paths to m files
%   destination_path (char): Path to output directory for rst files
% Note:
%  This requires a file mxdom2rst.xsl which is not part of this repository
%  (due to licencing concerns). The file was adapted from MATLAB's
%  mxdom2latex.xsl to output rst from MATLAB code.
for file_name_c = source_file_path_cell(:).'
    assert(numel(file_name_c) == 1);

    source_file_path = file_name_c{1};

    [~,name,ext] = fileparts(source_file_path);

    destination_file_path = [destination_path,name,'.rst'];

    PublishRST(source_file_path,destination_file_path)
end
end

function PublishRST(source_file_path,destination_file_path)
destination_folder = fileparts(destination_file_path);

[source_dir_path, source_file_name] = fileparts(source_file_path);
addpath(source_dir_path)

xml_file_name = publish(source_file_name,'format','xml','outputDir',destination_folder);

mxdom_file_name = '/home/ealvaro/Repos/uot/uot_code_private/mxdom2rst.xsl';
xslt(xml_file_name,mxdom_file_name,destination_file_path);

% Delete XML file
delete(xml_file_name);
end