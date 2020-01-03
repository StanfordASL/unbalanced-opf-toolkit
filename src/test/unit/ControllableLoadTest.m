function tests = ControllableLoadTest
% aaBoilerplateTest Verifies that ControllableLoadSpecs are validated correctly and that
%   constraints can be generated without errors for various valid specs.

% This enables us to run the test directly instead of only through runtests
call_stack = dbstack;

% Call stack has only one element if function was called directly
if ~any(contains({call_stack.name},'runtests'))
    this_file_name = mfilename();
    runtests(this_file_name)
end

tests = functiontests(localfunctions);
end

function setupOnce(test_case)
aaSetupPath

test_case.TestData.abs_tol_equality = 5e-6;
end

function controllable_load_spec_array = GetValidControllableLoadSpecArray(n_time_step)
phase_vector_array = [
    1,1,1;
    0,1,1;
    1,0,1;
    1,1,0;
    0,0,1;
    1,0,0;
    0,1,0;
    ];

n_phase_vector_array = size(phase_vector_array,1);

controllable_load_spec_cell = cell(n_phase_vector_array);

for i_phase_vector_array = 1:n_phase_vector_array
    phase = phase_vector_array(i_phase_vector_array,:);

    n_phase = sum(phase);

    s_zeros = zeros(n_time_step,n_phase);
    s_ones  = ones(n_time_step,n_phase);

    % Sum across phases
    s_ones_sum = ones(n_time_step,1);

    s_delta_ones = ones(n_time_step - 1,n_phase);

    controllable_load_spec_cell{i_phase_vector_array} = [
        % With scalar constraints
        uot.ControllableLoadSpec('charger_632_2','l632',phase,'p_min_va',0,'p_max_va',1,'q_min_va',0,'q_max_va',1,'s_mag_max_va',1,'s_sum_mag_max_va',1,'p_delta_max_va',1,'q_delta_max_va',1);
        % Per phase constraints
        uot.ControllableLoadSpec('charger_632_2','l632',phase,'p_min_va',s_zeros(1,:),'p_max_va',s_ones(1,:),'q_min_va',s_zeros(1,:),'q_max_va',s_ones(1,:),'s_mag_max_va',s_ones(1,:),'s_sum_mag_max_va',s_ones_sum(1,:),'p_delta_max_va',s_delta_ones(1,:),'q_delta_max_va',s_delta_ones(1,:));
        % Per time-step constraints
        uot.ControllableLoadSpec('charger_632_2','l632',phase,'p_min_va',s_zeros(:,1),'p_max_va',s_ones(:,1),'q_min_va',s_zeros(:,1),'q_max_va',s_ones(:,1),'s_mag_max_va',s_ones(:,1),'s_sum_mag_max_va',s_ones_sum(:,1),'p_delta_max_va',s_delta_ones(:,1),'q_delta_max_va',s_delta_ones(:,1));
        % Full matrix constraints
        uot.ControllableLoadSpec('charger_632_2','l632',phase,'p_min_va',s_zeros,'p_max_va',s_ones,'q_min_va',s_zeros,'q_max_va',s_ones,'s_mag_max_va',s_ones,'s_sum_mag_max_va',s_ones_sum,'p_delta_max_va',s_delta_ones,'q_delta_max_va',s_delta_ones);
        ];
end

controllable_load_spec_array = vertcat(controllable_load_spec_cell{:});
end

function controllable_load_spec_array = GetInvalidControllableLoadSpecArray(n_time_step)

% These should fail due to wrong phases in load
controllable_load_spec_cell{1} = [
    uot.ControllableLoadSpec('charger_652_13','l652',[1,1,1]);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,1,0]);
    uot.ControllableLoadSpec('charger_652_13','l652',[0,1,1]);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,1]);
    uot.ControllableLoadSpec('charger_652_13','l652',[0,1,0]);
    uot.ControllableLoadSpec('charger_652_13','l652',[0,0,1]);
    ];

n_phase = 2;
s_zeros = zeros(n_time_step,n_phase);
s_ones  = ones(n_time_step,n_phase);

s_delta_ones = ones(n_time_step - 1,n_phase);

% These should fail due to too many phases in bound
controllable_load_spec_cell{2} = [
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'p_min_va',s_zeros);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'p_max_va',s_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'q_min_va',s_zeros);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'q_max_va',s_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'s_mag_max_va',s_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'p_delta_max_va',s_delta_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'q_delta_max_va',s_delta_ones);
];

n_phase = 1;
n_time_step_x = n_time_step - 1;
s_zeros = zeros(n_time_step_x,n_phase);
s_ones  = ones(n_time_step_x,n_phase);

s_delta_ones = ones(n_time_step_x - 1,n_phase);

% These should fail due to too few time steps
controllable_load_spec_cell{3} = [
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'p_min_va',s_zeros);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'p_max_va',s_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'q_min_va',s_zeros);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'q_max_va',s_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'s_mag_max_va',s_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'p_delta_max_va',s_delta_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'q_delta_max_va',s_delta_ones);
];

n_time_step_x = n_time_step + 1;
s_zeros = zeros(n_time_step_x,n_phase);
s_ones  = ones(n_time_step_x,n_phase);

s_delta_ones = ones(n_time_step_x - 1,n_phase);

% These should fail due to too many time steps
controllable_load_spec_cell{4} = [
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'p_min_va',s_zeros);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'p_max_va',s_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'q_min_va',s_zeros);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'q_max_va',s_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'s_mag_max_va',s_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'p_delta_max_va',s_delta_ones);
    uot.ControllableLoadSpec('charger_652_13','l652',[1,0,0],'q_delta_max_va',s_delta_ones);
];


% These should fail due to too few phases in bound
controllable_load_spec_cell{5} = [
    uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1],'p_min_va',s_zeros);
    uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1],'p_max_va',s_ones);
    uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1],'q_min_va',s_zeros);
    uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1],'q_max_va',s_ones);
    uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1],'s_mag_max_va',s_ones);
    uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1],'p_delta_max_va',s_delta_ones);
    uot.ControllableLoadSpec('charger_632_2','l632',[1,1,1],'q_delta_max_va',s_delta_ones);
];

controllable_load_spec_cell{6} = [
  % This should fail due to invalid bus name
    uot.ControllableLoadSpec('charger_632_2','l6322',[1,1,1],'p_min_va',s_zeros);
];

controllable_load_spec_array = vertcat(controllable_load_spec_cell{:});
end

function TestValidateSpec(test_case)

opf_problem = GetBasicOPFproblem();

n_time_step = opf_problem.n_time_step;

valid_controllable_load_spec_array = GetValidControllableLoadSpecArray(n_time_step);

n_valid_controllable_load_spec_array = numel(valid_controllable_load_spec_array);

% These shoud all work
for i = 1:n_valid_controllable_load_spec_array
   spec = valid_controllable_load_spec_array(i);

   controllable_load = uot.ControllableLoad(spec,opf_problem);
   controllable_load.ValidateSpec();
end

invalid_controllable_load_spec_array = GetInvalidControllableLoadSpecArray(n_time_step);

n_invalid_controllable_load_spec_array = numel(invalid_controllable_load_spec_array);

% These shoud all fail
for i = 1:n_invalid_controllable_load_spec_array
   spec = invalid_controllable_load_spec_array(i);

   controllable_load = uot.ControllableLoad(spec,opf_problem);

   verifyError(test_case,@() controllable_load.ValidateSpec(),'');
end
end

function TestGetConstraintArray(test_case)

opf_problem = GetBasicOPFproblem();

n_time_step = opf_problem.n_time_step;

valid_controllable_load_spec_array = GetValidControllableLoadSpecArray(n_time_step);

n_valid_controllable_load_spec_array = numel(valid_controllable_load_spec_array);

% These shoud all work
for i = 1:n_valid_controllable_load_spec_array
   spec = valid_controllable_load_spec_array(i);

   controllable_load = uot.ControllableLoad(spec,opf_problem);

   constraint_array = controllable_load.GetConstraintArray();

   diagnostics = optimize(constraint_array);

   diagnostic_string = sprintf('Error solving at i = %d',i);
   verifyEqual(test_case,diagnostics.problem,0,diagnostic_string)
end


end















