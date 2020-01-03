classdef BusSpec_Splitphased < uot.AbstractBusSpec
    % Class to specify power buses with split phases
    %
    % Synopsis::
    %
    %   obj = BusSpec_Splitphased(name,parent_phase,u_nom_v)
    %
    % Arguments:
    %   name (char): Bus name
    %   parent_phase (logical): Phase to which the split phase bus is connected (as :term:`logical phase vector`)
    %   u_nom_v (double): nominal voltage (in volt)
    
    
    methods
        function obj = BusSpec_Splitphased(name,parent_phase,u_nom_v)
            obj@uot.AbstractBusSpec(name,u_nom_v)
            obj.parent_phase = parent_phase;
        end
    end

    properties
       parent_phase logical {uot.MustBeUnbalancedSinglePhaseVectorOrEmpty(parent_phase)} % bus parent phase
    end
end