classdef LoadCostSpec < uot.Spec
    methods
        function obj = LoadCostSpec(load_name,varargin)
            % Allow no-argument constructor for pre-allocation
            if nargin > 0
                obj.load_name = load_name;

                p = inputParser;
                addParameter(p,'cost_p',[]);
                addParameter(p,'cost_q',[]);

                parse(p,varargin{:});

                obj.cost_p = p.Results.cost_p;
                obj.cost_q = p.Results.cost_q;
            end
        end
    end

   properties
       load_name(1,:) char;
       cost_p(1,:) double {mustBeReal};
       cost_q(1,:) double {mustBeReal};
   end
end