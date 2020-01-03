function tests = AbstractNetworkTest
% Verifies that 0 is less than 1

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

function TestBusStackIndexCell(test_case)
load_case = GetLoadCaseIEEE_13_NoRegs_Manual();

network = load_case.network;

bus_stack_index = uot.UnstackPhaseConsistent((1:network.n_bus_has_phase).',network.bus_has_phase);

bus_stack_index_cell_ref = cell(network.n_bus,1);

for i = 1:network.n_bus
   bus_phase = network.bus_has_phase(i,:);

   bus_stack_index_cell_ref{i} = bus_stack_index(i,bus_phase);
end

verifyEqual(test_case,network.bus_stack_index_cell,bus_stack_index_cell_ref);
end


function TestLinkStackIndexCell(test_case)
load_case = GetLoadCaseIEEE_13_NoRegs_Manual();

network = load_case.network;

link_stack_index = uot.UnstackPhaseConsistent((1:network.n_link_has_phase_from).',network.link_has_phase_from);

link_stack_index_cell_ref = cell(network.n_link,1);

for i = 1:network.n_link
   link_phase = network.link_has_phase_from(i,:);

   link_stack_index_cell_ref{i} = link_stack_index(i,link_phase);
end

verifyEqual(test_case,network.link_stack_index_cell,link_stack_index_cell_ref);
end













