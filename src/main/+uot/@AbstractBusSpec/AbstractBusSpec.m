classdef (Abstract) AbstractBusSpec < uot.Spec & matlab.mixin.Heterogeneous
    % AbstractBusSpec Class with common functionality to specify buses of the power network
    %
    % Synopsis::
    %
    %   obj = AbstractBusSpec(name,u_nom_v)
    %   obj = AbstractBusSpec(name,u_nom_v,'bus_type',bus_type)
    %
    % Arguments:
    %   name (char): Bus name
    %   u_nom_v (double): Nominal voltage (in volt)
    %
    % Keyword Arguments:
    %   'bus_type' (uot.enum.BusType): Bus type
    
    methods
        function obj = AbstractBusSpec(name,u_nom_v,varargin)
            obj.name = name;
            obj.u_nom_v = u_nom_v;

            p = inputParser;
            addParameter(p,'bus_type',uot.enum.BusType.PQ);
            parse(p,varargin{:});
            obj.bus_type = p.Results.bus_type;
        end
    end

    properties
       name(1,:) char % bus name
       u_nom_v(1,1) double {mustBeReal,mustBePositive} = 1  % bus nominal voltage in volt
       bus_type(1,1) uot.enum.BusType = uot.enum.BusType.PQ % bus type
    end
end