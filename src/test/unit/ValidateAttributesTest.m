function tests = ValidateAttributesTest
% ValidateAttributes Verifies functionality of uot.ValidateAttributes

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

function TestValidateAttributes(test_case)
phase_valid = logical([1,0,0]);
phase_invalid = logical([1,0,1]);

% This should not an throw error
uot.ValidateAttributes(phase_valid,{'logical'},{@uot.IsPhaseVector,'size',[1,3],@uot.IsUnbalancedSinglePhaseVector});

verifyError(test_case,@() uot.ValidateAttributes(phase_invalid,{'logical'},{@uot.AssertIsPhaseVector,'size',[1,3],@uot.AssertIsUnbalancedSinglePhaseVector}),'ValidateAttributes:HandleFailure');
end