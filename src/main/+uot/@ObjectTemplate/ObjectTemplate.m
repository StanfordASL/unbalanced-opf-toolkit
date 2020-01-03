classdef ObjectTemplate < uot.Object
    % Template class for uot.Object.
    %
    % Synopsis::
    %
    %   obj = uot.ObjectTemplate(spec,'param1',val1)
    %
    % Description:
    %   This class is intended as a starting point to develop classes that
    %   derive from ``uot.Object``.
    %
    %
    %   We can also itemize
    %
    %     - item 1
    %     - item 2
    %
    % Arguments:
    %   spec (|uot.SpecTemplate|): Object specification
    %
    % Keyword Arguments:
    %   'param1' (:class:`uot.PCCloadSpec<+uot.@PCCloadSpec.PCCloadSpec>`): Parameter
    %
    %
    % Note:
    %  Possibly add a note here
    %
    % Example::
    %
    %   object = uot.ObjectTemplate(uot.SpecTemplate())
    %
    % See Also:
    %   |uot.SpecTemplate|
    %
    % Todo:
    %
    %   - Write documentation
    %

    % .. Line with 80 characters for reference #####################################


    methods
        function obj = ObjectTemplate(spec,varargin)
            % Note: constructor does not have doc (it would repeat what is already in class)

            validateattributes(spec,{'uot.LoadCaseZIPspec'},{'scalar'},mfilename,'spec',1);
            obj@uot.Object(spec);
        end


        function [val_1,val_2] = ComputeValue(obj,arg_1)
            % Compute value based on current state
            %
            % Synopsis::
            %
            %   val = object.ComputeValue()
            %
            % Description:
            %   Method description
            %
            %
            %   We can also itemize
            %
            %     - item 1
            %     - item 2
            %
            % Arguments:
            %   arg_1 (double): Argument 1
            %
            %
            % Returns:
            %
            %   - **val_1** (double) - Val1
            %   - **val_2** (double) - Val2
            %
            % Note:
            %  Possibly add a note here
            %
            % Example::
            %
            %   val = object.ComputeValue(arg_1);
            %
            % See Also:
            %   |uot.SpecTemplate|
            %

            % .. Line with 80 characters for reference #####################################


            val = 1;
        end

    end

    properties
        prop_1 % Property 1 (double)
        prop_2 % Property 2 (logical)
    end

    % Protected
    methods (Access = protected)
       res = ProtectedMethod(obj,arg)
    end

    properties (Access = protected)
        protected_prop_1 % Property 1 (double)
        protected_prop_2 % Property 2 (logical)
    end

    % Private
    methods (Access = private)
       res = PrivateMethod(obj,arg)
    end

    properties (Access = private)
        private_prop_1 % Property 1 (double)
        private_prop_2 % Property 2 (logical)
    end







end