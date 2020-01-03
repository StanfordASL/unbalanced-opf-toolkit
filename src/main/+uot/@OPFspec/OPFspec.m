classdef OPFspec < uot.ProblemSpec
    % Class to specify an |uot.OPFproblem|.
    %
    % Synopsis::
    %
    %   spec = uot.OPFspec(pf_surrogate_spec,controllable_load_spec_array,objective_spec,...
    %       pcc_voltage_spec,voltage_magnitude_spec,'pcc_load_spec',pcc_load_spec)
    %
    % Description:
    %   This class incorporates several specifications needed to specify an |uot.OPFproblem|
    %
    % Arguments:
    %   pf_surrogate_spec (|uot.AbstractPowerFlowSurrogateSpec|): Power flow surrogate specification
    %   controllable_load_spec_array (|uot.ControllableLoadSpec| ): Array of controllable load specifications
    %   objective_spec (|uot.ObjectiveSpec|): Objective specification
    %   pcc_voltage_spec (|uot.PCCvoltageSpec|): Voltage at the |pcc| specification
    %   voltage_magnitude_spec (|uot.VoltageMaginitudeSpec|): Specification of constraints on voltage magnitude
    %
    % Keyword Arguments:
    %   'pcc_load_spec' (:class:`uot.PCCloadSpec<+uot.@PCCloadSpec.PCCloadSpec>`): Specification of constraints on the |pcc| load
    %
    % See Also:
    %   |uot.OPFproblem|
    %

    % .. Line with 80 characters for reference #####################################

    methods
        function obj = OPFspec(pf_surrogate_spec,controllable_load_spec_array,objective_spec,pcc_voltage_spec,voltage_magnitude_spec,varargin)
            % Allow no-argument constructor for preallocation
            if nargin > 0
                obj.pf_surrogate_spec = pf_surrogate_spec;
                obj.controllable_load_spec_array = controllable_load_spec_array;
                obj.objective_spec = objective_spec;
                obj.pcc_voltage_spec = pcc_voltage_spec;
                obj.voltage_magnitude_spec = voltage_magnitude_spec;

                p = inputParser;
                addParameter(p,'pcc_load_spec',uot.PCCloadSpec());
                parse(p,varargin{:});

                obj.pcc_load_spec = p.Results.pcc_load_spec;
            end
        end
    end

    properties
        pf_surrogate_spec {uot.AssertIsInstance(pf_surrogate_spec,'uot.AbstractPowerFlowSurrogateSpec'), uot.NumelMustBeLessThanOrEqual(pf_surrogate_spec,1)} % Power flow surrogate specification (|uot.AbstractPowerFlowSurrogateSpec|)
        controllable_load_spec_array(:,1) {uot.AssertIsInstance(controllable_load_spec_array,'uot.ControllableLoadSpec')} % Array of controllable load specifications (|uot.ControllableLoadSpec|)
        objective_spec(1,1) uot.ObjectiveSpec % Array of controllable load specifications (|uot.ControllableLoadSpec|)
        pcc_voltage_spec uot.PCCvoltageSpec {uot.NumelMustBeLessThanOrEqual(pcc_voltage_spec,1)} % Array of controllable load specifications (|uot.PCCvoltageSpec|)
        voltage_magnitude_spec uot.VoltageMaginitudeSpec {uot.NumelMustBeLessThanOrEqual(voltage_magnitude_spec,1)} % Specification of constraints on the |pcc| load (|uot.VoltageMaginitudeSpec|)
        pcc_load_spec(1,1) uot.PCCloadSpec = uot.PCCloadSpec() % Specification of constraints on voltage magnitude  (|uot.PCCloadSpec|)
    end
end
