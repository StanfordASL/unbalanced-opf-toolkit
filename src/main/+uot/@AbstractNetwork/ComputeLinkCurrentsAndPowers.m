function [I_link_from_array,I_link_to_array,S_link_from_array,S_link_to_array] = ComputeLinkCurrentsAndPowers(obj,U_array,T_array)
% Compute currents and power flow through links for a given voltage profile
%
% Synopsis::
%
%   [I_link_from_array,I_link_to_array,S_link_from_array,S_link_to_array] = network.ComputeCurrentInjectionFromVoltage(U_array,T_array)
%
% Description:
%   This method computes the current flowing through the network's links according
%   to Eq. 4 in :cite:`Bazrafshan2018b`. The power flows are then computed from these
%   currents.
%
% Arguments:
%   U_array (double): :term:`Phase-consistent array` with voltage mangitudes
%   T_array (double): :term:`Phase-consistent array` with voltage angles
%
% Returns:
%
%   - **I_link_from_array** (double) - :term:`Phase-consistent array` with link currents leaving the from bus
%   - **I_link_to_array** (double) - :term:`Phase-consistent array` with link currents arriving at the to bus
%   - **S_link_from_array** (double) - :term:`Phase-consistent array` with power flows leaving the from bus
%   - **S_link_to_array** (double) - :term:`Phase-consistent array` with power flows arriving at the to bus

% .. Line with 80 characters for reference #####################################

V_array = uot.PolarToComplex(U_array,T_array);

n_array = size(U_array,3);

I_link_from_array = uot.ComplexNan(obj.n_link,obj.n_phase,n_array);
I_link_to_array = uot.ComplexNan(obj.n_link,obj.n_phase,n_array);
S_link_from_array = uot.ComplexNan(obj.n_link,obj.n_phase,n_array);
S_link_to_array = uot.ComplexNan(obj.n_link,obj.n_phase,n_array);

for i_link = 1:obj.n_link
    from_i = obj.link_data_array(i_link).from_i;
    to_i = obj.link_data_array(i_link).to_i;

    link_phase_from = obj.link_has_phase_from(i_link,:);
    link_phase_to = obj.link_has_phase_to(i_link,:);

    % Based on Bazrafshan2018b, Eqs. (4a) and (4b)
    Y_from = obj.link_data_array(i_link).Y_from;
    Y_to = obj.link_data_array(i_link).Y_to;
    Y_shunt_from = obj.link_data_array(i_link).Y_shunt_from;
    Y_shunt_to = obj.link_data_array(i_link).Y_shunt_to;


    for i_array = 1:n_array
        v_from = V_array(from_i,link_phase_from,i_array).';
        v_to = V_array(to_i,link_phase_to,i_array).';

        i_link_from = Y_shunt_from*v_from - Y_from*v_to;
        i_link_to = Y_shunt_to*v_to - Y_to*v_from;

        I_link_from_array(i_link,link_phase_from,i_array) = i_link_from;
        I_link_to_array(i_link,link_phase_to,i_array) = i_link_to;

        S_link_from_array(i_link,link_phase_from,i_array) = conj(i_link_from).*v_from;
        S_link_to_array(i_link,link_phase_to,i_array) = conj(i_link_to).*v_to;
    end
end

% Verify that we did not miss anything
uot.AssertPhaseConsistency(I_link_from_array,obj.link_has_phase_from);
uot.AssertPhaseConsistency(I_link_to_array,obj.link_has_phase_to);
uot.AssertPhaseConsistency(S_link_from_array,obj.link_has_phase_from);
uot.AssertPhaseConsistency(S_link_to_array,obj.link_has_phase_to);
end