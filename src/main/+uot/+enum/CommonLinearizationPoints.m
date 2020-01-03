classdef CommonLinearizationPoints
    % Enum to define common linearization points used in power flow surrogates
    % NoLoad: no load
    % FlatVoltage: all nodes have voltage magnitude 1
    % PowerFlowBaseCaseFirstTimeStep: solve powerflow for base case (i.e., without
    % controllable loads) in the first time step. Linearize at the resulting solution
    enumeration
        FlatVoltage,NoLoadFirstTimeStep,PFbaseCaseFirstTimeStep
    end

    methods
        function [U_ast,T_ast] = GetVoltageAtLinearizationPoint(obj,load_case,u_pcc_array,t_pcc_array)
            network = load_case.network;

            switch obj
                case uot.enum.CommonLinearizationPoints.FlatVoltage
                    U_ast = uot.FillPhaseConsistentMatrix(1,network.bus_has_phase);

                    % is_positively_sequenced indicates if voltage at PCC is positively sequenced (angle =
                    % [0, -120, 120]) or negatively sequenced (angle =  [0,120,-120])
                    if network.spec.is_positively_sequenced
                        t_flat = [0, -120, 120]*pi/180;
                    else
                        t_flat = [0, 120, -120]*pi/180;
                    end

                    T_pre = repmat(t_flat,network.n_bus,1);
                    T_ast = uot.ExtractPhaseConsistentValues(T_pre,network.bus_has_phase);

                case uot.enum.CommonLinearizationPoints.NoLoadFirstTimeStep
                    [U_ast,T_ast] = network.ComputeNoLoadVoltage(u_pcc_array(1,:),t_pcc_array(1,:));

                case uot.enum.CommonLinearizationPoints.PFbaseCaseFirstTimeStep
                    % TODO: this needs to be fixed once power flow can be solved for some time steps
                    [U_array,T_array] = load_case.SolvePowerFlow(u_pcc_array,t_pcc_array);

                    U_ast = U_array(:,:,1);
                    T_ast = T_array(:,:,1);

                otherwise
                    error('Invalid linearization point.')
            end



        end

    end
end