%Assert than A is nan where there is no phase and not nan where
%there is phase.
%This also takes care of checking dimensions.
function AssertPhaseConsistency(A, has_phase)
has_phase_expanded = uot.ExpandBound(A, has_phase);
assert(all(isnan(A(~has_phase_expanded))));
% Is numeric check is necesary because isnan is not defined for sdpvar
assert(all(~isnan(A(has_phase_expanded & isnumeric(A)))));
end