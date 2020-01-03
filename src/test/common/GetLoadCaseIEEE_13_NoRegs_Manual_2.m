function load_case = GetLoadCaseIEEE_13_NoRegs_Manual_2()
% Same as GetLoadCaseIEEE_13_NoRegs_Manual_2, but with larger resistance for
% the switch. The reason for this is that the small resistance gives trouble
% to optimization solvers.

load_case_pre = GetLoadCaseIEEE_13_NoRegs_Manual();

network_pre = load_case_pre.network;

switch_link_number = network_pre.GetLinkNumber('l671','l692');

network_spec = load_case_pre.network.spec;

Y_switch_siemens = (1 + 1i)/(1e-2)*eye(3);
network_spec.link_spec_array(switch_link_number) = uot.LinkSpec_Unbalanced('671-692',[1,1,1],'l671','l692',Y_switch_siemens);

network = network_spec.Create();

load_case = uot.LoadCaseZIP(load_case_pre.spec,network);
end