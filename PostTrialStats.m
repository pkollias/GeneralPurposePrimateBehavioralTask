function PostTrialStats

%%% Task - specific

%%
global opts stats cache

stats.TrialNo = cache.TrialNo;
stats.BlockNo = cache.BlockNo;
stats.CorrectTrials = sum(ismember(cache.lists.StopCondition,opts.Behavior.StopConditionCorrect));
stats.AttemptedTrials = sum(ismember(cache.lists.StopCondition,opts.Behavior.StopConditionAttempted));
stats.BreakFixTrials = sum(ismember(cache.lists.StopCondition,opts.Behavior.StopConditionBroken));
stats.Accuracy = mean(ismember(cache.lists.StopCondition(ismember(cache.lists.StopCondition,opts.Behavior.StopConditionAttempted)),opts.Behavior.StopConditionCorrect));
stats.BreakFixRate = mean(ismember(cache.lists.StopCondition(~ismember(cache.lists.StopCondition,opts.Behavior.StopConditionIdle)),opts.Behavior.StopConditionBroken));
stats.NumRewards = nansum(cache.lists.NumRewards);
stats.IdleTime = round(nansum(cache.lists.IdleTime)/60);
stats.RunningTime = round((GetSecs-stats.StartTime)/60);

PostTrialCacheStats;