function tests = VoltageIsPositivelySequencedTest
% aaBoilerplateTest verifies xx

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

function TestVoltageIsPositivelySequenced(test_case)
a = uot.FortescueOperator();

v_pos = [1,a^2,a];
t_pos = angle(v_pos);

v_neg = [1,a,a^2];
t_neg = angle(v_neg);

verifyTrue(test_case,uot.VoltageIsPositivelySequenced(v_pos));
verifyTrue(test_case,uot.VoltageIsPositivelySequenced(t_pos));

verifyFalse(test_case,uot.VoltageIsPositivelySequenced(v_neg));
verifyFalse(test_case,uot.VoltageIsPositivelySequenced(t_neg));
end