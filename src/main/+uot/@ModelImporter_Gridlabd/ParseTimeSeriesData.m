% This function is static
function [time_stamp_array,data_table_cell] = ParseTimeSeriesData(file_name)
% Parses a file in timeseries format
% time_stamp_array is an array of posix timestamps
% data_table_cell is a cell array with one table per time step

text = fileread(file_name);
block_cell = strsplit(text,'\n\n');

n_blocks = numel(block_cell);

header_block = block_cell{1};
column_header_cell = ParseHeaderBlock(header_block,file_name);

footer_block = block_cell{n_blocks};
VerifyFooterBlock(footer_block,file_name);

% Minus 2 because it excludes header and footer block
n_time_stamp = n_blocks - 2;

time_stamp_array = zeros(n_time_stamp,1);
data_table_cell = cell(n_time_stamp,1);

for i_time_stamp = 1:n_time_stamp
    block = block_cell{i_time_stamp + 1};
    [time_stamp,data_table] = ParseBodyBlock(block,column_header_cell);

    time_stamp_array(i_time_stamp) = time_stamp;
    data_table_cell{i_time_stamp} = data_table;
end

end

function column_header_cell = ParseHeaderBlock(header_block,file_name)
header_line_cell = strsplit(header_block,'\n');

assert(numel(header_line_cell) == 2,'Header block must have 2 lines.')

start_line = header_line_cell{1};
start_line_ref = 'Start of timeseries';
assert(strcmp(start_line,start_line_ref),'Initial line of %s is not as expected.',file_name);

header_line = header_line_cell{2};
column_header_cell = strsplit(header_line,',');
end

function VerifyFooterBlock(footer_block,file_name)
footer_line_cell = strsplit(footer_block,'\n');

assert(numel(footer_line_cell) == 1,'Footer block must have 1 line.')

footer_line = footer_line_cell{1};

footer_line_ref = 'End of timeseries';
assert(strcmp(footer_line,footer_line_ref),'Final line of %s is not as expected.',file_name);
end


function [time_stamp,data_table] = ParseBodyBlock(block,column_header_cell)

[timestamp_line,content_lines] = strtok(block,newline);

time_stamp_cell = textscan(timestamp_line,'Timestamp: %d');
time_stamp = time_stamp_cell{1};

% We need to create a temporary file because readtable does not work with
% text directly.
temp_file_name = ['temp_block_',uot.GenerateRandomString(5),'.txt'];
f_h = fopen(temp_file_name,'w');
fprintf(f_h,content_lines);
fclose(f_h);

data_table = readtable(temp_file_name,'ReadVariableNames',false);
data_table.Properties.VariableNames = column_header_cell;

delete(temp_file_name);
end
