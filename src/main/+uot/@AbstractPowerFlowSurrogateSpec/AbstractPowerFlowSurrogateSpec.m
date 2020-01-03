classdef (Abstract) AbstractPowerFlowSurrogateSpec < uot.Spec & uot.Factory & matlab.mixin.Heterogeneous
    % Abstract class to specify a power flow surrogate
    %
    % Description:
    %   The main purpose of an AbstractPowerFlowSurrogateSpec is telling 
    %   the |uot.OPFproblem| how to instantiate the powerflow surrogate. 
    %   This is necessary because there is a chicken and egg problem: to instantiate
    %   the surrogate, we need to pass it the OPFproblem. At the same time,
    %   to instantiate the OPFproblem we need the power flow surrogate.

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = AbstractPowerFlowSurrogateSpec()
        end
    end

    methods (Abstract)
        pf_surrogate = Create(obj,varargin)
    end
end