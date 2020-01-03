function [U_array,T_array, p_pcc_array, q_pcc_array,opf_problem] = SolveApproxPowerFlow(load_case,u_pcc_array,t_pcc_array)
    pf_surrogate_spec = uot.PowerFlowSurrogateSpec_Gan2014_LP;
    [U_array,T_array, p_pcc_array, q_pcc_array,opf_problem] = uot.AbstractPowerFlowSurrogate.SolveApproxPowerFlowHelper(pf_surrogate_spec,load_case,u_pcc_array,t_pcc_array);
end