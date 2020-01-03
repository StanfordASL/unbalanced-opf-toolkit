function Initialize(obj)
% Runs Gridlab and imports data

% Create directory for Gridlabd output
[mkdir_status,mkdir_msg] = mkdir(obj.spec.directory_gld_model,obj.spec.directory_uot_output);

if mkdir_status ~= 1
    error('Could not create directory: %s',mkdir_msg);
end

obj.CleanGridlabdDirectory();

obj.CreateOPFdataFile();

obj.RunGridlabd();

bus_spec_array = obj.ParseBusData();
link_spec_array =  obj.ParseLinkData();

network_spec = uot.NetworkSpec(bus_spec_array,link_spec_array,'s_base_va',obj.spec.s_base_va);
obj.network = network_spec.Create();

[obj.load_case,obj.load_case_prerot] = obj.ParseLoadData();

% The following are meant for use in validation
[V_ref_array,V_ref_array_v] = obj.ParseVoltageData();

[obj.U_ref_array_v,obj.T_ref_array] = uot.ComplexToPolar(V_ref_array_v);

obj.U_ref_array = uot.ComplexToPolar(V_ref_array);

phase_pcc = obj.network.bus_has_phase(1,:);

obj.u_pcc_array = permute(obj.U_ref_array(1,phase_pcc,:),[3,2,1]);
obj.t_pcc_array = permute(obj.T_ref_array(1,phase_pcc,:),[3,2,1]);

[obj.p_pcc_ref_array,obj.q_pcc_ref_array,obj.p_pcc_ref_array_va,obj.q_pcc_ref_array_va] = obj.ParsePCCloadData();

[obj.I_link_from_ref_array,obj.I_link_to_ref_array,obj.I_link_from_ref_array_a,obj.I_link_to_ref_array_a] = obj.ParseLinkCurrentData();

if obj.validate
   obj.Validate();
end
end








