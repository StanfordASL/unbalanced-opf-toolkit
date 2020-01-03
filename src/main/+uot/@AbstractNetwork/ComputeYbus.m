function Ybus = ComputeYbus(obj)

% Take care of diagonal blocks
Ybus_diag_cell = arrayfun(@(n_phase) zeros(n_phase),obj.n_phase_in_bus,'UniformOutput',false);

for i_link = 1:obj.n_link
    from_i = obj.link_data_array(i_link).from_i;
    to_i = obj.link_data_array(i_link).to_i;

    phase_link_from = obj.link_has_phase_from(i_link,:);
    phase_link_to = obj.link_has_phase_to(i_link,:);

    phase_from = obj.bus_has_phase(from_i,:);
    phase_to = obj.bus_has_phase(to_i,:);

    phase_match_from_in_link = phase_link_from(phase_from);
    phase_match_link_in_from = phase_from(phase_link_from);

    Y_shunt_from = obj.link_data_array(i_link).Y_shunt_from;
    Ybus_diag_from_pre = Ybus_diag_cell{from_i};

    Ybus_diag_from_contribution = zeros(size(Ybus_diag_from_pre));
    Ybus_diag_from_contribution(phase_match_from_in_link,phase_match_from_in_link) = Y_shunt_from(phase_match_link_in_from,phase_match_link_in_from);

    Ybus_diag_cell{from_i} = Ybus_diag_from_pre + Ybus_diag_from_contribution;

    phase_match_to_in_link = phase_link_to(phase_to);
    phase_match_link_in_to = phase_to(phase_link_to);

    Y_shunt_to = obj.link_data_array(i_link).Y_shunt_to;
    Ybus_diag_to_pre = Ybus_diag_cell{to_i};

    Ybus_diag_to_contribution = zeros(size(Ybus_diag_to_pre));
    Ybus_diag_to_contribution(phase_match_to_in_link,phase_match_to_in_link) = Y_shunt_to(phase_match_link_in_to,phase_match_link_in_to);

    Ybus_diag_cell{to_i} = Ybus_diag_to_pre + Ybus_diag_to_contribution;
end

Ybus_diag = uot.Spblkdiag(Ybus_diag_cell{:});

% Add off-diagonals using sparse notation
n_entry = 2*obj.n_phase_from_in_link(:).'*obj.n_phase_to_in_link(:);

row_vec = zeros(n_entry,1);
col_vec = zeros(n_entry,1);
val_vec = zeros(n_entry,1);

i_entry = 0;

for i_link = 1:obj.n_link
    from_i = obj.link_data_array(i_link).from_i;
    to_i = obj.link_data_array(i_link).to_i;

    phase_link_from = obj.link_has_phase_from(i_link,:);
    phase_link_to = obj.link_has_phase_to(i_link,:);

    is_from = false(obj.n_bus,obj.n_phase);
    is_from(from_i,phase_link_from) = true;
    is_from_stack = uot.StackPhaseConsistent(is_from,obj.bus_has_phase);

    from_indices = find(is_from_stack);

    is_to = false(obj.n_bus,obj.n_phase);
    is_to(to_i,phase_link_to) = true;
    is_to_stack = uot.StackPhaseConsistent(is_to,obj.bus_has_phase);

    to_indices = find(is_to_stack);

    Y_from = obj.link_data_array(i_link).Y_from;
    Y_to = obj.link_data_array(i_link).Y_to;

    n_phase_link_from = sum(phase_link_from);
    n_phase_link_to = sum(phase_link_to);

    for i_phase = 1:n_phase_link_from
        for j_phase = 1:n_phase_link_to

            % Add Y_from
            i_entry = i_entry + 1;

            row_vec(i_entry) = from_indices(i_phase);
            col_vec(i_entry) = to_indices(j_phase);
            val_vec(i_entry) = -Y_from(i_phase,j_phase);
        end
    end

   for i_phase = 1:n_phase_link_to
        for j_phase = 1:n_phase_link_from

            % Add Y_to
            i_entry = i_entry + 1;

            row_vec(i_entry) = to_indices(i_phase);
            col_vec(i_entry) = from_indices(j_phase);
            val_vec(i_entry) = -Y_to(i_phase,j_phase);
        end
    end

end

if (i_entry ~= n_entry)
   warning('Unexpected number of entries.')
end

Ybus_offdiag = sparse(row_vec,col_vec,val_vec,obj.n_bus_has_phase,obj.n_bus_has_phase);

Ybus = Ybus_offdiag + Ybus_diag;
end
