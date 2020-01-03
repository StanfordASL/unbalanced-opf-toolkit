function [Ybus_SS, Ybus_SN, Ybus_NS, Ybus_NN,Ybus_NN_L,Ybus_NN_U] = PartitionYbus(obj)
% PartitionYbus returns the parts of Ybus for the swing bus and for the
% other buses.
% Partition is done as in Bazrafshan2018.

Ybus_SS = obj.Ybus(1:obj.n_phase_pcc,1:obj.n_phase_pcc);

Ybus_SN = obj.Ybus(1:obj.n_phase_pcc,(obj.n_phase_pcc + 1):end);

Ybus_NS = obj.Ybus((obj.n_phase_pcc + 1):end,1:obj.n_phase_pcc);

Ybus_NN = obj.Ybus((obj.n_phase_pcc + 1):end,(obj.n_phase_pcc + 1):end);

[Ybus_NN_L,Ybus_NN_U] = lu(Ybus_NN);
end