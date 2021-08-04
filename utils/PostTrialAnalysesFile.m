function PostTrialAnalysesFile

%%
global specs stats cache


%%
try,
    
    if ~mod(cache.TrialNo,10),
        fid = fopen(specs.Code.AnalysesPath,'w');

        str = [sprintf('%s - %s\n\n',specs.Version.ScriptRun,datestr(datetime('now','TimeZone','local','Format','eee MM/dd, HH:mm'))) ...
                sprintf('Trial %d - Block %d\n',stats.TrialNo,stats.BlockNo) ...
                sprintf('Correct Trials: %.0f/%.0f (%.2f)\n',stats.CorrectTrials,stats.AttemptedTrials,stats.Accuracy) ...
                sprintf('Broken Trials: %.0f (%.2f)\n',stats.BreakFixTrials,stats.BreakFixRate) ...
                sprintf('Reward drops: %.0f\n',stats.NumRewards) ...
                sprintf('Running Time: %.1f\n', stats.RunningTime) ...
                sprintf('Idle Time: %.1f\n', stats.IdleTime) ...
                strcat(sprintf('Outcome Queue: ... '),sprintf('%d ',stats.CacheStats.StopConditionQueue))];

        fprintf(fid,sprintf(str));

        fclose(fid);
    end
end