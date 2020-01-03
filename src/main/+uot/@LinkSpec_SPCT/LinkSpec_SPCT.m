classdef LinkSpec_SPCT < uot.AbstractLinkSpec
    % LineSpec_SPCT Class to specify single-phase center tapped transformers (SPCTs)

    methods
        function obj = LinkSpec_SPCT(name,parent_phase,from,to,Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens,Y_shunt_to_siemens)
            % LineSpec_SPCT Creates a LineSpec_SPCT object
            %   obj = LineSpec_SPCT(name,parent_phase,from,to,Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens,Y_shunt_to_siemens)

            created_from_Y_link = false;
            obj@uot.AbstractLinkSpec(name,from,to,Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens,Y_shunt_to_siemens,created_from_Y_link);

            obj.parent_phase = parent_phase;
        end


    end

    % Implemented from uot.AbstractLineSpec
    methods
       ValidateYmatrices(obj)
       ValidateFromAndToBuses(obj,bus_spec_from,bus_spec_to)
    end

    properties
        parent_phase(1,:) logical {uot.MustBeUnbalancedSinglePhaseVectorOrEmpty(parent_phase)} % line parent phase
    end
end


