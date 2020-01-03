function tests = PermuteDims1and3Test
% PermuteDims1and3Test Verifies that uot.PermuteDims1and3 is correct

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

function TestMatrixPermuteDims1and3(test_case)
A = randi(10,5,6);
A_s = sdpvar(size(A,1),size(A,2),'full');

assign(A_s,A)

Aperm = value(uot.PermuteDims1and3(A_s));
Aperm_ref = uot.PermuteDims1and3(A);

verifyEqual(test_case,Aperm,Aperm_ref)
end

function TestTensorPermuteDims1and3(test_case)
A = randi(10,5,6,7);
A_s = sdpvar(size(A,1),size(A,2),size(A,3),'full');

assign(A_s,A)

Aperm = value(uot.PermuteDims1and3(A_s));
Aperm_ref = uot.PermuteDims1and3(A);

verifyEqual(test_case,Aperm,Aperm_ref)
end