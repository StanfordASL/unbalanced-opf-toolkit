classdef PowerFlowSurrogateSpec_Gan2014_LP < uot.AbstractPowerFlowSurrogateSpec
    % Class to specify the linear power flow surrogate presented in :cite:`Gan2014`.
    %
    % Synopsis::
    %
    %   spec = PowerFlowSurrogateSpec_Gan2014_LP()
    %
    % See Also:
    %   |uot.PowerFlowSurrogate_Gan2014_LP|

    % .. Line with 80 characters for reference #####################################



    methods
        function obj = PowerFlowSurrogateSpec_Gan2014_LP()
        end
    end

    % Implemented abstract methods from uot.AbstractPowerFlowSurrogateSpec
    methods
        function pf_surrogate = Create(obj,varargin)
            % Returns an instance of |uot.PowerFlowSurrogate_Gan2014_LP|.
            pf_surrogate = uot.PowerFlowSurrogate_Gan2014_LP(obj,varargin{:});
        end
    end
end