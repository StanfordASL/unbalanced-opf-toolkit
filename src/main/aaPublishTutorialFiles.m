function aaPublishTutorialFiles()
    % Publish .m files for tutorial to rst format.

    PublishPFandOPFfiles()
    PublishPowerFlowSurrogateFiles()
end

function PublishPFandOPFfiles()
    file_path_prefix = [GetPathToUOT, 'src/demo/'];
    file_name_cell = {
        [file_path_prefix, 'aaUseCase_SolvePF.m'];
        [file_path_prefix, 'aaUseCase_SolveOPF.m'];
    };

    destination_path = [GetPathToUOT, 'docs/tutorial/'];
    uot.PublishFilesToRST(file_name_cell, destination_path)
end

function PublishPowerFlowSurrogateFiles()
    file_path_prefix = [GetPathToUOT, 'src/demo/PowerFlowSurrogateTutorial/'];
    file_name_cell = {
        [file_path_prefix, 'aaReplicatePaperResults.m'];
        [file_path_prefix, 'aaInstantiateBarebones.m'];
        [file_path_prefix, 'aaSolveOPF.m'];
        [file_path_prefix, 'aaDebugPowerFlowSurrogate.m'];
    };

    destination_path = [GetPathToUOT, 'docs/tutorial/new_power_flow_surrogate/'];
    uot.PublishFilesToRST(file_name_cell, destination_path)
end