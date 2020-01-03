function tests = GetYshuntBusTest
% aaBoilerplateTest Verifies uot.Network.GetYshuntBus

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
end

function TestGetYshuntBus(test_case)

% This test assumes that the network has only power links and
% wye-wye transformers.
model_importer = GetModelImporterIEEE_13_NoRegs();

model_importer.Initialize();

network = model_importer.network;

Y_shunt_bus_ref_cell = arrayfun(@(n_phase_in_bus) zeros(n_phase_in_bus),network.n_phase_in_bus,'UniformOutput',false);

for i_link = 1:network.n_link
    link_data = network.link_data_array(i_link);
    from_i = link_data.from_i;
    to_i = link_data.to_i;

    % According to Bazrafshan2017, Table IV
    % For power links, this is equal to 1/2 the link's shunt admittance
    % For wye-wye transformers it is zero
    Y_shunt_bus_from_link = link_data.Y_shunt_from - link_data.Y_from;
    Y_shunt_bus_to_link = link_data.Y_shunt_to - link_data.Y_to;

    phase_link = network.link_has_phase_from(i_link,:);

    phase_bus_from = network.bus_has_phase(from_i,:);
    phase_bus_to = network.bus_has_phase(to_i,:);

    phase_match_from = phase_link(phase_bus_from);
    phase_match_to = phase_link(phase_bus_to);

    Y_shunt_bus_from = Y_shunt_bus_ref_cell{from_i};
    Y_shunt_bus_from(phase_match_from,phase_match_from) = Y_shunt_bus_from(phase_match_from,phase_match_from) + Y_shunt_bus_from_link;
    Y_shunt_bus_ref_cell{from_i} = Y_shunt_bus_from;

    Y_shunt_bus_to = Y_shunt_bus_ref_cell{to_i};
    Y_shunt_bus_to(phase_match_to,phase_match_to) = Y_shunt_bus_to(phase_match_to,phase_match_to) + Y_shunt_bus_to_link;
    Y_shunt_bus_ref_cell{to_i} = Y_shunt_bus_to;
end

% Recall that in uot.Network, Y_shunt_bus is rounded to network.Y_shunt_bus_prec
% to get rid of numerical noise.
abs_tol = 10^(-(network.Y_shunt_bus_prec - 1));
for i_bus = 1:network.n_bus
    Y_shunt_bus = network.GetYshuntBus(i_bus);
    Y_shunt_bus_ref = Y_shunt_bus_ref_cell{i_bus};

    diagnostic_string = sprintf('Y_shunt_bus do not match for i_bus = %d',i_bus);

    verifyEqual(test_case,Y_shunt_bus,Y_shunt_bus_ref,'AbsTol',abs_tol,diagnostic_string);
end
end



