function link_spec_array =  ParseLinkData(obj)
% Reads link data from Gridlabd and creates link_spec_array from them

file_name_link_data_full = obj.spec.PrependUOToutputDirFull(obj.spec.file_name_link_data);

file_text = fileread(file_name_link_data_full);

file_text_cell = strsplit(file_text,'\n');

% Start from 2 because first line is header
link_spec_cell = cellfun(@(str) MapStringToLinkSpec(str),file_text_cell(2:end),'UniformOutput',false);




link_spec_array = vertcat(link_spec_cell{:});
end

function link_spec = MapStringToLinkSpec(str)
string_expr = '([^,]+)'; % Matches strings
logical_expr = '([01])'; % Matches logical values
matrix_expr = '(\[[^\]]+\])'; % Matches matrices in Matlab format "A = [1,0;2,1]"

% The colums of the branch data file are as follows:
% Name,From,To,PhaseA,PhaseB,PhaseC,PhaseD,PhaseS,LinkType,Yfrom,Yto,YSfrom,YSto
% Thus we want to capture, 3 strings (Name,From,To), 5 logical (PhaseA,PhaseB,PhaseC,PhaseD,PhaseS)
% 1 string (LinkType) and 4 matrices (Yfrom,Yto,YSfrom,YSto).
expr_cell = [
    repmat({string_expr},3,1);
    repmat({logical_expr},5,1);
    string_expr;
    repmat({matrix_expr},4,1);
    ];

expr = strjoin(expr_cell,',');

[tokens,matches] = regexp(str,expr,'tokens','match');

% Verify that the whole str was matched
if ~strcmp(matches{1},str) || numel(tokens)~= 1
    error('Error reading maping string %s',str);
end

tokens = tokens{1};

name = tokens{1};
from = tokens{2};
to = tokens{3};

phase = str2double(tokens(4:6));

% Gridlab represents open switches as links with no phases. They should not
% be added
if sum(phase) > 0
    % Currently not used
    phase_delta = str2double(tokens(7));

    split_phase = str2double(tokens(8));

    link_type_gridlab = tokens{9};

    Y_from_siemens_pre = str2num(tokens{10});
    Y_to_siemens_pre = str2num(tokens{11});

    Y_shunt_from_siemens_pre = str2num(tokens{12});
    Y_shunt_to_siemens_pre = str2num(tokens{13});

    T_s2 = diag([1,-1]);

    % For now, we only treat triplex lines and SPCTs differently.
    switch link_type_gridlab
        case 'triplex_line'
            % Gridlabd makes a convention of flipping the signs of currents
            % in phase 2 of split-phase buses. In order to avoid having to
            % do this, we multiply here the relevant matrices with T_s2.
            Y_from_siemens = T_s2*Y_from_siemens_pre(1:2,1:2);
            Y_to_siemens = T_s2*Y_to_siemens_pre(1:2,1:2);
            Y_shunt_from_siemens = T_s2*Y_shunt_from_siemens_pre(1:2,1:2);
            Y_shunt_to_siemens = T_s2*Y_shunt_to_siemens_pre(1:2,1:2);

            parent_phase = phase;

            link_spec = uot.LinkSpec_Splitphased(name,parent_phase,from,to,Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens,Y_shunt_to_siemens);

        case 'spct'
            % We also need to transform the sign of the SPCT. However, in
            % this case Gridlab also flips the sign of the whole Y_from and
            % Y_shunt_from matrices. Hence, we need to multiply them with
            % T_s2.
            parent_phase = phase;

            parent_phase_i = find(parent_phase);

            Y_from_siemens = Y_from_siemens_pre(parent_phase_i,1:2);
            Y_to_siemens = -T_s2*Y_to_siemens_pre(1:2,parent_phase_i);
            Y_shunt_from_siemens = Y_shunt_from_siemens_pre(parent_phase_i,parent_phase_i);
            Y_shunt_to_siemens = -T_s2*Y_shunt_to_siemens_pre(1:2,1:2);

            link_spec = uot.LinkSpec_SPCT(name,parent_phase,from,to,Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens,Y_shunt_to_siemens);

        otherwise
            link_spec = uot.LinkSpec_Unbalanced(name,phase,from,to,Y_from_siemens_pre,Y_to_siemens_pre,Y_shunt_from_siemens_pre,Y_shunt_to_siemens_pre);
    end

else
    link_spec = [];
end
end
















