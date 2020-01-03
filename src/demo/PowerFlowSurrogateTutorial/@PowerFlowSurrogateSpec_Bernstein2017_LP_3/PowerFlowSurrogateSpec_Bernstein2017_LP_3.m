classdef PowerFlowSurrogateSpec_Bernstein2017_LP_3 < uot.AbstractPowerFlowSurrogateSpec
    % Class to specify the power flow surrogate presented in :cite:`Bernstein2017`
    %
    % Synopsis::
    %
    %   spec = PowerFlowSurrogateSpec_Bernstein2017_LP_3()
    %
    % Note:
    % 	We add the suffix ``_3`` to distinguish this implementation from the others that were developed in the course of the tutorial.
    %
    % See Also:
    %   |PowerFlowSurrogate_Bernstein2017_LP_3|

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = PowerFlowSurrogateSpec_Bernstein2017_LP_3()
        end
    end

    % Implemented abstract methods from uot.AbstractPowerFlowSurrogateSpec
    methods
        function pf_surrogate = Create(obj,varargin)
            pf_surrogate = PowerFlowSurrogate_Bernstein2017_LP_3(obj,varargin{:});
        end
    end
end