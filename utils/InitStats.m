function InitStats

%%% Task - specific

%%
global stats

stats.StartTime = GetSecs;
stats.TrialNo = 0;
stats.BlockNo = 0;

stats.CorrectTrials = NaN;
stats.AttemptedTrials = NaN;
stats.BreakFixTrials = NaN;
stats.Accuracy = NaN;
stats.BreakFixRate = NaN;
stats.NumRewards = NaN;
stats.IdleTime = NaN;
stats.RunningTime = NaN;

stats.EndTime = NaN;

InitCacheStats;