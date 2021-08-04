function PostTrialCacheStats

%%% Task - specific

%%
global opts stats cache

stats.CacheStats.TrialsInBlock = numel(find(cache.lists.BlockNo == cache.BlockNo));
stats.CacheStats.AttemptedTrialsInBlock = numel(find(cache.lists.BlockNo == cache.BlockNo & ismember(cache.lists.StopCondition,opts.Behavior.StopConditionAttempted)));
stats.CacheStats.BlockPerf = mean(ismember(cache.lists.StopCondition((cache.lists.BlockNo == cache.BlockNo) & ismember(cache.lists.StopCondition,opts.Behavior.StopConditionAttempted)),opts.Behavior.StopConditionCorrect));
stats.CacheStats.StopConditionQueue = cache.lists.StopCondition(max(1,end-4):end);