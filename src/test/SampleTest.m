function tests = SampleTest
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

function TestBoilerPlate(test_case)
verifyLessThan(test_case, 0, 1,...
    '0 < 1');
end