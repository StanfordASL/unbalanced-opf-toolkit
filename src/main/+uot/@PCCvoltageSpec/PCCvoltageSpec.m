classdef PCCvoltageSpec < uot.Spec
    % uot.PCCvoltageSpec Class to specify voltage at PCC for an OPF problem
    %



    methods
        function obj = PCCvoltageSpec(u_pcc_array,t_pcc_array)
            % PCCvoltageSpec Constructs a PCCvoltageSpec object
            %   obj = PCCvoltageSpec(u_pcc_array,t_pcc_array)
            %


            obj.u_pcc_array = u_pcc_array;
            obj.t_pcc_array = t_pcc_array;
            obj.v_pcc_array = uot.PolarToComplex(u_pcc_array,t_pcc_array);
        end

    end

    properties
        u_pcc_array(:,3) double {mustBeNonnegative}
        t_pcc_array(:,3) double {mustBeReal}
        v_pcc_array(:,3) double
    end
end