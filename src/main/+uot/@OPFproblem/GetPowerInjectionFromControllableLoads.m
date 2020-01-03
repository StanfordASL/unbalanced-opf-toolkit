function [P_inj_controllable_array,Q_inj_controllable_array] = GetPowerInjectionFromControllableLoads(obj)

network = obj.network;

% We need to sum the entries in controllable_loads and put them in
% matrices of power injection. We do this through sparse sdpvars. See https://yalmip.github.io/naninmodel/

controllable_load_cell = obj.controllable_load_hashtable.values.';

if isempty(controllable_load_cell)
    P_inj_controllable_array = zeros(network.n_bus,network.n_phase);
    Q_inj_controllable_array = zeros(network.n_bus,network.n_phase);
    return
end

controllable_load_phase_cell = cellfun(@(controllable_load) controllable_load.spec.phase,controllable_load_cell,'UniformOutput',false);
controllable_load_phase_array = cell2mat(controllable_load_phase_cell);

attachment_point_cell = cellfun(@(controllable_load) controllable_load.spec.attachment_bus,controllable_load_cell,'UniformOutput',false);
attachment_bus_array = cellfun(@(attachement_point) network.GetBusNumber(attachement_point), attachment_point_cell);

% This vector contains the attachement bus of the controllable load,
% repeated for the number of phases. For example [2;2;3;3;3] if
% controllable load 1 is attached to bus 2 and has phase [0,1,1], and
% controllable_load 2 is attached to bus 3 and has phase [1,1,1].
attachment_bus_array_expanded = repmat(attachment_bus_array,1,network.n_phase);

% We do the transpositions to get row_vec in the right order
attachment_bus_array_expanded_tr = attachment_bus_array_expanded.';
row_vec = attachment_bus_array_expanded_tr(controllable_load_phase_array.');

% This vector contains the phases. In the above example, [2;3;1;2;3];
col_vec_cell = cellfun(@(controllable_load_phase) find(controllable_load_phase).',controllable_load_phase_cell,'UniformOutput',false);
col_vec = cell2mat(col_vec_cell);

assert(all(size(row_vec) == size(col_vec)))

% This matrix stores the controllable load's sdpvar. It matches in
% dimension 1 with row_vec and col_vec and extends in dimension 2
% through n_time_step.
% Note that loads are negative power injections
value_mat_p_cell = cellfun(@(controllable_load) -controllable_load.p.',controllable_load_cell,'UniformOutput',false);
value_mat_p = vertcat(value_mat_p_cell{:});

value_mat_q_cell = cellfun(@(controllable_load) -controllable_load.q.',controllable_load_cell,'UniformOutput',false);
value_mat_q = vertcat(value_mat_q_cell{:});

assert(all(size(value_mat_p) == size(value_mat_q)));

% If empty, add a second dimension so that indexing makes sense
if isempty(value_mat_p)
    value_mat_p = zeros(0,obj.n_time_step);
    value_mat_q = zeros(0,obj.n_time_step);
end

assert(all(size(value_mat_p) == [size(row_vec,1),obj.n_time_step]));

P_inj_controllable_cell = cell(obj.n_time_step,1);
Q_inj_controllable_cell = cell(obj.n_time_step,1);

for i_time_step = 1:obj.n_time_step
    P_inj_controllable = sparse(row_vec,col_vec,value_mat_p(:,i_time_step),network.n_bus,network.n_phase);
    Q_inj_controllable = sparse(row_vec,col_vec,value_mat_q(:,i_time_step),network.n_bus,network.n_phase);

    % Yalmip sometimes decides that matrices are symmetric. This is
    % just to be cautious.
    assert(~issymmetric(P_inj_controllable))
    assert(~issymmetric(Q_inj_controllable))

    P_inj_controllable_cell{i_time_step} = P_inj_controllable;
    Q_inj_controllable_cell{i_time_step} = Q_inj_controllable;
end

if obj.n_time_step > 1
    % There is an error in Yalmip if this is executed for a single timestep
    P_inj_controllable_array = cat(3,P_inj_controllable_cell{:});
    Q_inj_controllable_array = cat(3,Q_inj_controllable_cell{:});
else
    P_inj_controllable_array = P_inj_controllable_cell{1};
    Q_inj_controllable_array = Q_inj_controllable_cell{1};
end
end

