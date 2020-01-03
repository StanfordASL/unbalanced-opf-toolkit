function solution_table = ParsePowerFlowSolutionData(solution_file_name)
% ParsePowerFlowSolutionData parse power flow solution from file
%   ParsePowerFlowSolutionData(solution_file_name) opens file named
%   solution_file_name to parse its contents.
%   Returns a table with bus names and voltages.
%   File must have the following format:
%   Name    Mag1     Ang1     Mag2   Ang2      Mag3   Ang3
data_table = readtable(solution_file_name);

n_bus = size(data_table,1);
n_phase = 3;

V = zeros(n_bus,n_phase);

for i_bus = 1:n_bus
    V(i_bus,1) = uot.PolarToComplex(data_table.Mag1(i_bus),deg2rad(data_table.Ang1(i_bus)));
    V(i_bus,2) = uot.PolarToComplex(data_table.Mag2(i_bus),deg2rad(data_table.Ang2(i_bus)));
    V(i_bus,3) = uot.PolarToComplex(data_table.Mag3(i_bus),deg2rad(data_table.Ang3(i_bus)));
end

solution_table = table(V,'RowNames',data_table.Name);
end