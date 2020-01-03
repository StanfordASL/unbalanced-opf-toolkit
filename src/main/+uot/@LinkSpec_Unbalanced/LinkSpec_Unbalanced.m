classdef LinkSpec_Unbalanced < uot.AbstractLinkSpec
    % LinkSpec_Unbalanced Class to specify unbalanced power lines

    methods
        function obj = LinkSpec_Unbalanced(name,phase,from,to,varargin)
            % LinkSpec_Unbalanced Creates a LinkSpec_Unbalanced object
            %   obj = LinkSpec_Unbalanced(name,phase,from,to,Y_line_siemens)
            %   obj = LinkSpec_Unbalanced(name,phase,from,to,Y_line_siemens,Y_shunt_line_siemens)
            %   obj = LinkSpec_Unbalanced(name,phase,from,to,Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens,Y_shunt_to_siemens)

            n_varargin = numel(varargin);

            phase = logical(phase);
            assert(uot.IsUnbalancedPhaseVector(phase));

            if n_varargin == 1 || n_varargin == 2
                [Y_from_siemens,Y_to_siemens,...
                    Y_shunt_from_siemens, Y_shunt_to_siemens] ...
                    = uot.LinkSpec_Unbalanced.ConvertLineMatrices(phase,varargin{:});

                created_from_Y_link = true;

            elseif n_varargin == 4
                Y_from_pre_siemens = varargin{1};
                Y_to_pre_siemens = varargin{2};
                Y_shunt_from_pre_siemens = varargin{3};
                Y_shunt_to_pre_siemens = varargin{4};

                uot.ValidateMatrixIsPhaseConsistent(phase,Y_from_pre_siemens);
                uot.ValidateMatrixIsPhaseConsistent(phase,Y_to_pre_siemens);
                uot.ValidateMatrixIsPhaseConsistent(phase,Y_shunt_from_pre_siemens);
                uot.ValidateMatrixIsPhaseConsistent(phase,Y_shunt_to_pre_siemens);

                Y_from_siemens = uot.ExtractPhaseValuesFromMatrix(phase,Y_from_pre_siemens);
                Y_to_siemens = uot.ExtractPhaseValuesFromMatrix(phase,Y_to_pre_siemens);
                Y_shunt_from_siemens = uot.ExtractPhaseValuesFromMatrix(phase,Y_shunt_from_pre_siemens);
                Y_shunt_to_siemens = uot.ExtractPhaseValuesFromMatrix(phase,Y_shunt_to_pre_siemens);

                created_from_Y_link = false;
            else
                error('Invalid number of arguments');
            end

            obj@uot.AbstractLinkSpec(name,from,to,Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens,Y_shunt_to_siemens,created_from_Y_link);

            obj.phase = phase;

        end
    end

    % Implemented from uot.AbstractLineSpec
    methods
       ValidateYmatrices(obj)
       ValidateFromAndToBuses(obj,bus_spec_from,bus_spec_to)
    end

    properties
        phase logical {uot.MustBeMustBeUnbalancedPhaseVectorOrEmpty(phase)} % line phase
    end

    methods (Static)
        function [Y_from_siemens,Y_to_siemens,Y_shunt_from_siemens, Y_shunt_to_siemens] ...
                = ConvertLineMatrices(phase,varargin)

            n_varargin = numel(varargin);

            if n_varargin == 1 || n_varargin == 2
                Y_line_pre_siemens = varargin{1};

                uot.ValidateMatrixIsPhaseConsistent(phase,Y_line_pre_siemens);

                Y_line_siemens = uot.ExtractPhaseValuesFromMatrix(phase,Y_line_pre_siemens);

                Y_from_siemens = Y_line_siemens;
                Y_to_siemens = Y_line_siemens;

                if n_varargin == 1
                    Y_shunt_from_siemens = Y_line_siemens;
                    Y_shunt_to_siemens = Y_line_siemens;
                else
                    Y_shunt_line_pre_siemens = varargin{2};
                    uot.ValidateMatrixIsPhaseConsistent(phase,Y_shunt_line_pre_siemens);

                    Y_shunt_line_siemens = uot.ExtractPhaseValuesFromMatrix(obj.phase,Y_shunt_line_pre_siemens);

                    Y_shunt_from_siemens = Y_line_siemens + 1/2*Y_shunt_line_siemens;
                    Y_shunt_to_siemens = Y_line_siemens + 1/2*Y_shunt_line_siemens;
                end
            else
                error('Invalid number of arguments.');
            end
        end
    end
end


