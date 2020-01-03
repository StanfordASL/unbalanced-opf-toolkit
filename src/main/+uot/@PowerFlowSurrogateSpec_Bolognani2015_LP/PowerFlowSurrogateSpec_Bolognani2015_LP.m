classdef PowerFlowSurrogateSpec_Bolognani2015_LP < uot.AbstractPowerFlowSurrogateSpec
    % Class to specify the power flow surrogate presented in :cite:`Bolognani2015`.
    %
    % Synopsis::
    %
    %   spec = PowerFlowSurrogateSpec_Bolognani2015_LP()
    %
    % See Also:
    %   |uot.PowerFlowSurrogate_Bernstein2017_LP|

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = PowerFlowSurrogateSpec_Bolognani2015_LP()



        end

    end


    % Implemented abstract methods from uot.AbstractPowerFlowSurrogateSpec
    methods
        function pf_surrogate = Create(obj,varargin)
            % Returns an instance of |uot.PowerFlowSurrogate_Bolognani2015_LP|.
            pf_surrogate = uot.PowerFlowSurrogate_Bolognani2015_LP(obj,varargin{:});
        end
    end



end