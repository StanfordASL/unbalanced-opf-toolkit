classdef (Abstract) ModelImporter < uot.Object
    methods
        function obj = ModelImporter(spec)
            validateattributes(spec,{'uot.ModelImporterSpec'},{'scalar'})
            obj@uot.Object(spec)
        end

        function Initialize(obj)
            % Does set-up work that is time consuming and
            % we don't want to do in the constructor.
        end
    end


end