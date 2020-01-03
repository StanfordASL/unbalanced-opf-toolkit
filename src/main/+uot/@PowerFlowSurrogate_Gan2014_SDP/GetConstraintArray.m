function constraint_array = GetConstraintArray(obj)
constraint_array_base = GetConstraintArray@uot.PowerFlowSurrogate_Gan2014(obj);

% Clear M_eigenvalue_ratio_max
obj.M_eigenvalue_ratio_max = [];

opf_problem = obj.opf_problem;
network = opf_problem.network;
n_time_step = opf_problem.n_time_step;

sdp_constraint_cell = cell(network.n_link,n_time_step);

for i_time_step = 1:n_time_step
    for i_link = 1:network.n_link
        M_link = obj.GetMlink(i_link,i_time_step);

        sdp_constraint = M_link >= 0;
        sdp_constraint_cell{i_link,i_time_step} = uot.TagConstraintIfNonEmpty(sdp_constraint,sprintf('SDP constraint link %d, time_step = %d',i_link,i_time_step));
    end
end

sdp_constraint_array = vertcat(sdp_constraint_cell{:});

constraint_array = [
    constraint_array_base;
    sdp_constraint_array;
    ];
end