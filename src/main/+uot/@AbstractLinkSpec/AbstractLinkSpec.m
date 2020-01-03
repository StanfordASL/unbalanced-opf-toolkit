classdef (Abstract) AbstractLinkSpec < uot.Spec & matlab.mixin.Heterogeneous
    % AbstractLinkSpec Class with common functionality to specify links of the power network

    methods
        function obj = AbstractLinkSpec(name,from,to,Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens,Y_shunt_to_siemens,created_from_Y_link)
            obj.name = name;

            obj.from = from;
            obj.to = to;

            obj.Y_from_siemens = Y_from_siemens;
            obj.Y_to_siemens = Y_to_siemens;
            obj.Y_shunt_from_siemens = Y_shunt_from_siemens;
            obj.Y_shunt_to_siemens = Y_shunt_to_siemens;

            obj.created_from_Y_link = created_from_Y_link;
        end

        [Y_from,Y_to,Y_shunt_from,Y_shunt_to] = ComputeNormalizedAdmittanceMatrices(obj,u_nom_from_v,u_nom_to_v,s_base_va)
    end

    methods (Abstract)
       ValidateYmatrices(obj)
       ValidateFromAndToBuses(obj)
    end

    properties
        name(1,:) char % link name
        from(1,:) char % link start bus
        to(1,:) char % link end bus

        Y_from_siemens(:,:) double % from-side admittance matrix
        Y_to_siemens(:,:) double % to-side admittance matrix
        Y_shunt_from_siemens(:,:) double % from-side shunt admittance matrix
        Y_shunt_to_siemens(:,:) double % to-side shunt admittance matrix

        created_from_Y_link(1,1) logical = false % flag to denote that LinkSpec was created using Y_line_siemens
    end
end

