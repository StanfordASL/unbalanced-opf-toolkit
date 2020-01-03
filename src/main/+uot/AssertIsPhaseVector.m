function AssertIsPhaseVector(phase)
is_phase_vector = uot.IsPhaseVector(phase);
assert(is_phase_vector,'Phase is not a phase vector')
end