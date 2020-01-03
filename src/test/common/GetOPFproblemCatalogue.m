function opf_problem_array = GetOPFproblemCatalogue()
% Returns an array of available OPFproblems for testing purposes

opf_problem_array = [
    GetOPFproblem_ChargerMaximization_IEEE_13_NoRegs_Manual();
    GetOPFproblem_ChargerMaximization_IEEE_13_NoRegs_Schedule();
    GetOPFproblem_ChargerMaximization_IEEE_13_NoRegs_Schedule_2();
    GetOPFproblem_ChargerMaximization_PL_1_peak();
];
end