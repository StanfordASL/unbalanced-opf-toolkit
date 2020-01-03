classdef PowerFlowSurrogate_Gan2014 < uot.AbstractPowerFlowSurrogate
    % Abstract class with common functionality for |uot.PowerFlowSurrogate_Gan2014_LP|
    % and |uot.PowerFlowSurrogate_Gan2014_SDP|.
    %
    % See Also:
    %   |uot.PowerFlowSurrogateSpec_Gan2014_SDP|, |uot.PowerFlowSurrogate_Gan2014_LP|

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = PowerFlowSurrogate_Gan2014(spec,opf_problem,decision_variables)
            obj@uot.AbstractPowerFlowSurrogate(spec,opf_problem,decision_variables)
       end

        U_array = ComputeVoltageMangitudeEstimate(obj)

        % Implemented abstract methods from uot.AbstractPowerFlowSurrogate
        constraint_array = GetConstraintArray(obj)
    end

    properties
        % Z_link_norm_min is by AdjustZlink in GetConstraintArray and
        % SolveApproxPowerFlowAlt (which is static). Z_link_norm_min_default
        % is a common default value but can be overriden in both cases.
        % For GetConstraintArray, by changing the Z_link_norm_min property
        % and in SolveApproxPowerFlowAlt through a keyword argument.
        %
        % To disable scaling set to 0
        Z_link_norm_min(1,1) double {mustBeReal,mustBeNonnegative} ...
            = uot.PowerFlowSurrogate_Gan2014.Z_link_norm_min_default
    end

    properties (Constant, Access = protected)
        % See comment for Z_link_norm_min
        % This value was chosen through trial and error to balance
        % modeling accuracy vs numerical performance
        Z_link_norm_min_default = 2e-6;
    end

    methods (Static, Access = protected)
       decision_variables = DefineDecisionVariables(opf_problem)
       WarnIfNetworkHasShunts(network)
       Z_link_adjusted = AdjustZlink(Z_link, Z_link_norm_min)
    end
end