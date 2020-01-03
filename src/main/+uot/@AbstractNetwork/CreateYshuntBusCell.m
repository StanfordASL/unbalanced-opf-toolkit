function Y_shunt_bus_cell = CreateYshuntBusCell(obj)
% This function creates a struct with the shunt admittances of each bus.
% Note that this is different from the shunt admittances of the links
% given as Y_shunt_from and Y_shunt_to. The shunt admittance of each bus
% is given by summing the quantity (Y_from - Y_shunt_from) for each link
% connected to the bus (considering phases)
%
% In a bus connected only to power lines (i.e., not transformers or regulators)
% Y_shunt_bus is the sum of shunt admittance matrices of the lines connected
% to the bus.

% The phase indicator matrix has one column per phase. The rows have
% one element per bus-phase.
% phase_indicator_matrix(i_bus_phase,i_phase) is one if i_bus_phase is
% of phase i_phase and zero otherwise.
phase_indicator_matrix = zeros(obj.n_bus_has_phase,obj.n_phase);

for i_phase = 1:obj.n_phase
    phase_matrix = zeros(obj.n_bus,obj.n_phase);
    phase_matrix(:,i_phase) = 1;

    phase_indicator_matrix(:,i_phase) = uot.StackPhaseConsistent(phase_matrix,obj.bus_has_phase);
end

Y_shunt_bus_cell = cell(obj.n_bus,1);

for i_bus = 1:obj.n_bus
    bus_phase = obj.bus_has_phase(i_bus,:);

    bus_phase_matrix = false(obj.n_bus,obj.n_phase);
    bus_phase_matrix(i_bus,:) = bus_phase;

    % bus_phase_indicator is a vector with one element per bus-phase.
    % bus_phase_indicator(i_bus_phase) is one if i_bus_phase is in bus
    % i_bus
    bus_phase_indicator = uot.StackPhaseConsistent(bus_phase_matrix,obj.bus_has_phase);

    % Here we use find on bus_phase_indicator to get the bus-phase indices
    % that are present in bus i_bus
    % Matlab suggests using logical indexing but this is faster in this
    % case
    bus_phase_indicator_indices = find(bus_phase_indicator);

    % Y_bus_phase contains the rows of Ybus that represent bus-phases
    % present in bus i_bus
    Y_bus_phase = obj.Ybus(bus_phase_indicator_indices,:);

    % Finally, we sum the rows that correspond to the same phase
    Y_shunt_bus = Y_bus_phase*phase_indicator_matrix(:,bus_phase);

    % Get rid of numerical noise that may appear from the additions
    Y_shunt_bus = round(Y_shunt_bus,obj.Y_shunt_bus_prec);

    Y_shunt_bus_cell{i_bus} = Y_shunt_bus;
end

end