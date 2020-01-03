function L_link_cell = ComputeConstantLinkCurrents(obj,U_array,T_array)
% Sets constant link currents based on the given voltage profile

network = obj.opf_problem.network;

uot.AssertPhaseConsistency(U_array,network.bus_has_phase);
uot.AssertPhaseConsistency(T_array,network.bus_has_phase);

n_array_U = size(U_array,3);
n_array_T = size(T_array,3);
assert(n_array_T == n_array_U);

n_array = n_array_U;

n_time_step = obj.opf_problem.n_time_step;

assert(n_array == 1 || n_array == n_time_step);

I_link_array = network.ComputeLinkCurrentsAndPowers(U_array,T_array);

L_link_cell = cell(network.n_link,n_time_step);

for i_link = 1:network.n_link
    link_phase = network.link_has_phase_from(i_link,:);
    for i_time_step = 1:n_time_step

        if n_array == 1
            I_link = I_link_array(i_link,link_phase,1);
        else
            I_link = I_link_array(i_link,link_phase,i_time_step);
        end

        L_link_pre = I_link(:)*I_link(:)';

        % L is hermitian but might have some numerical noise. Get rid of it
        L_link = (L_link_pre + L_link_pre')/2;

        L_link_cell{i_link,i_time_step} = L_link;
    end
end

end