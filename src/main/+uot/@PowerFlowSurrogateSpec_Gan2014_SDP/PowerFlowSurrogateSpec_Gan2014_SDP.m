classdef PowerFlowSurrogateSpec_Gan2014_SDP < uot.AbstractPowerFlowSurrogateSpec
    % Class to specify the convex (SDP) power flow surrogate presented in :cite:`Gan2014`.
    %
    % Synopsis::
    %
    %   spec = PowerFlowSurrogateSpec_Gan2014_SDP()
    %
    % See Also:
    %   |uot.PowerFlowSurrogate_Gan2014_SDP|

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = PowerFlowSurrogateSpec_Gan2014_SDP()
        end
    end

    % Implemented abstract methods from uot.AbstractPowerFlowSurrogateSpec
    methods
        function pf_surrogate = Create(obj,varargin)
            % Returns an instance of |uot.PowerFlowSurrogate_Gan2014_SDP|.
            pf_surrogate = uot.PowerFlowSurrogate_Gan2014_SDP(obj,varargin{:});
        end
    end
end