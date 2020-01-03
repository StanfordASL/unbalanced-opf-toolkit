function link_number_array = GetLinkNumber(obj,varargin)
% link_number = obj.GetLinkNumber(link_name_pre) link_name_pre can be char or cell of char
% link_number = obj.GetLinkNumber(from,to) from and to can be
% bus indices (array) or bus names (char or cell of char).
% Returns nan if not a link
%

n_varargin = numel(varargin);

switch n_varargin
    case 1
        link_name_pre = varargin{1};

        % Convert to cell if necessary
        if ~isa(link_name_pre,'cell')
            link_name_cell = cellstr(link_name_pre);
        else
            link_name_cell = link_name_pre;
        end

        n_link_name_cell = numel(link_name_cell,1);

        link_number_array = zeros(n_link_name_cell,1);

        for i = 1:n_link_name_cell
            link_name = link_name_cell{i};

            if obj.link_name_map.isKey(link_name)
                link_number_array(i) = obj.link_name_map(link_name);
            else
                link_number_array(i) = nan;
            end
        end

    case 2
        from_i_pre = varargin{1};
        to_i_pre = varargin{2};

        if isa(from_i_pre,'double')
            from_i_array = from_i_pre;
        else
            from_i_array = obj.GetBusNumber(from_i_pre);
        end

        if isa(to_i_pre,'double')
            to_i_array = to_i_pre;
        else
            to_i_array = obj.GetBusNumber(to_i_pre);
        end

        link_hash_array = uot.HashEdgeUndirected(obj.n_bus,from_i_array,to_i_array);

        n_link_hash_array = numel(link_hash_array);

        link_number_array = zeros(n_link_hash_array,1);

        for i = 1:n_link_hash_array
            link_hash = link_hash_array(i);
            if obj.link_hash_map.isKey(link_hash)
                link_number_array(i) = obj.link_hash_map(link_hash);
            else
                link_number_array(i) = nan;
            end
        end

    otherwise
        error('Invalid number of arguments')
end


end