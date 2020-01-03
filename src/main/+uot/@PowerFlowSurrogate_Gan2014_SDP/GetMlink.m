function M_link = GetMlink(obj,link,i_time_step)
network = obj.opf_problem.network;

from_i = network.link_data_array(link).from_i;

link_phase = network.link_data_array(link).phase_from;

phase_from = network.bus_data_array(from_i).phase;
phase_match = link_phase(phase_from);

V_bus_from = obj.decision_variables.V_bus_cell{from_i,i_time_step}(phase_match,phase_match);

S_link = obj.decision_variables.S_link_cell{link,i_time_step};
L_link = obj.decision_variables.L_link_cell{link,i_time_step};

M_link = [...
    V_bus_from,S_link;
    S_link', L_link;
    ];
end