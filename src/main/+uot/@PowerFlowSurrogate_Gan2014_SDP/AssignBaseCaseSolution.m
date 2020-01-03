function [U_array,T_array,p_pcc_array,q_pcc_array] = AssignBaseCaseSolution(obj)
[U_array,T_array,p_pcc_array,q_pcc_array] = obj.opf_problem.SolvePFbaseCase();

V_array = uot.PolarToComplex(U_array,T_array);

network = obj.opf_problem.network;

n_time_step = obj.opf_problem.n_time_step;

for i_time_step = 1:n_time_step
    for i_bus = 1:network.n_bus
        bus_phase = network.bus_has_phase(i_bus,:);

        V_bus = V_array(i_bus,bus_phase,i_time_step);

        V_bus_hermitian = V_bus(:)*V_bus(:)';

        assign(obj.decision_variables.V_bus_cell{i_bus,i_time_step},V_bus_hermitian);
    end

    for i_link = 1:network.n_link
        link_phase = network.link_has_phase_from(i_link,:);

        from_i = network.link_data_array(i_link).from_i;
        to_i = network.link_data_array(i_link).to_i;

        V_from = V_array(from_i,link_phase,i_time_step);
        V_to = V_array(to_i,link_phase,i_time_step);

        Z_link = network.link_data_array(i_link).Z_from;

        I_link = Z_link \ (V_from(:) - V_to(:));

        S_link = V_from(:)*I_link(:)';

        L_link = I_link(:)*I_link()';

        assign(obj.decision_variables.S_link_cell{i_link,i_time_step},S_link);
        assign(obj.decision_variables.L_link_cell{i_link,i_time_step},L_link);
    end
end
end