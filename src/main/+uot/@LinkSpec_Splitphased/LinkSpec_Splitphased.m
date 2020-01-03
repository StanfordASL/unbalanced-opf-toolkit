classdef LinkSpec_Splitphased < uot.AbstractLinkSpec
    % LinkSpec_Splitphased Class to specify power lines with split-phases (Triplex lines in Gridlabd)

    methods
        function obj = LinkSpec_Splitphased(name,parent_phase,from,to,varargin)
            % LinkSpec_Splitphased Creates a LinkSpect object
            %   obj = LinkSpec_Splitphased(name,parent_phase,from,to,Y_link_siemens)
            %   obj = LinkSpec_Splitphased(name,parent_phase,from,to,Y_link_siemens,Y_shunt_link_siemens)
            %   obj = LinkSpec_Splitphased(name,parent_phase,from,to,Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens,Y_shunt_to_siemens)

            n_varargin = numel(varargin);

            if n_varargin == 1 || n_varargin == 2
                [Y_from_siemens,Y_to_siemens,...
                    Y_shunt_from_siemens, Y_shunt_to_siemens] ...
                    = uot.LinkSpec_Unbalanced.ConvertLinkMatrices(varargin{:});

                created_from_Y_link = true;

            elseif n_varargin == 4
                Y_from_siemens = varargin{1};
                Y_to_siemens = varargin{2};
                Y_shunt_from_siemens = varargin{3};
                Y_shunt_to_siemens = varargin{4};

                created_from_Y_link = false;

            else
                error('Invalid number of arguments');
            end

            obj@uot.AbstractLinkSpec(name,from,to,Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens,Y_shunt_to_siemens,created_from_Y_link);

            parent_phase = logical(parent_phase);
            obj.parent_phase = parent_phase;
        end


    end

    % Implemented from uot.AbstractLinkSpec
    methods
       ValidateYmatrices(obj)
       ValidateFromAndToBuses(obj,bus_spec_from,bus_spec_to)
    end

    properties
        parent_phase(1,:) logical {uot.MustBeMustBeUnbalancedPhaseVectorOrEmpty(parent_phase)} % link parent phase
    end

    methods (Static)
        function [Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens, Y_shunt_to_siemens] ...
                = ConvertLinkMatrices(varargin)

            n_varargin = numel(varargin);

            if n_varargin == 1 || n_varargin == 2
                Y_link_siemens = varargin{1};

                Y_from_siemens = Y_link_siemens;
                Y_to_siemens = Y_link_siemens;

                if n_varargin == 1
                    Y_shunt_from_siemens = Y_link_siemens;
                    Y_shunt_to_siemens = Y_link_siemens;
                else
                    Y_shunt_link_siemens = varargin{2};

                    Y_shunt_from_siemens = Y_link_siemens + 1/2*Y_shunt_link_siemens;
                    Y_shunt_to_siemens = Y_link_siemens + 1/2*Y_shunt_link_siemens;
                end
            else
                error('Invalid number of arguments.');
            end
        end
    end
end


