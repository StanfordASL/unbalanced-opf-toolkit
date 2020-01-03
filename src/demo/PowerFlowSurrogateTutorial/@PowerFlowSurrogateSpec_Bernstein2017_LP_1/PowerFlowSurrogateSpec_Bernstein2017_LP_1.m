classdef PowerFlowSurrogateSpec_Bernstein2017_LP_1 < uot.AbstractPowerFlowSurrogateSpec
    % Class to specify xx
    %
    % Synopsis::
    %
    %   obj = uot.SpecTemplate(bus,varargin)
    %
    % Description:
    %   This class is intended as a starting point to develop classes that
    %   derive from ``uot.Spec``.
    %
    %
    %   We can also itemize
    %
    %     - item 1
    %     - item 2
    %
    %
    % Arguments:
    %   bus (char): Bus name
    %
    % Keyword Arguments:
    %   'param1': Something.
    %
    % Returns:
    %   obj: Instance of `uot.SpecTemplate`.
    %
    % Note:
    %  Possibly add a note here
    %
    % Example::
    %
    %   object = uot.ObjectTemplate(uot.SpecTemplate())
    %
    % See Also:
    %   `uot.ObjectTemplate`
    %
    % Todo:
    %
    %   - Write documentation
    %
    % .. Line with 80 characters for reference #####################################

    methods
        function obj = PowerFlowSurrogateSpec_Bernstein2017_LP_1()
        end
    end

    % Implemented abstract methods from uot.AbstractPowerFlowSurrogateSpec
    methods
        function pf_surrogate = Create(obj,varargin)
            pf_surrogate = PowerFlowSurrogate_Bernstein2017_LP_1(obj,varargin{:});
        end
    end
end