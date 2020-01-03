classdef BusSpec_Unbalanced < uot.AbstractBusSpec
    % Class to specify unbalanced power buses
    %
    % Synopsis::
    %
    %   obj = BusSpec_Unbalanced(name,phase,u_nom_v)
    %   obj = BusSpec_Unbalanced(name,phase,u_nom_v,'bus_type',bus_type)
    %
    %
    % Arguments:
    %   name (char): Bus name
    %   phase (char): Bus' phase vector (as :term:`logical phase vector`)
    %   u_nom_v (double): nominal voltage (in volt)
    %
    % Keyword Arguments:
    %   'bus_type' (uot.enum.BusType): Bus type
      
    methods
        function obj = BusSpec_Unbalanced(name,phase,u_nom_v,varargin)
            obj@uot.AbstractBusSpec(name,u_nom_v,varargin{:})

            obj.phase = logical(phase);
        end
    end

    properties
       phase logical {uot.MustBeMustBeUnbalancedPhaseVectorOrEmpty(phase)} % bus phase
    end
end