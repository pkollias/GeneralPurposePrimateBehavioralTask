function PostTrialCache

%%% Task - specific

%%
global cache

cache.trial.Timing.EndTime = GetSecs;
cache.trial.Timing.IdleTime = cache.trial.Timing.StartTime-cache.trial.Timing.IdleStartTime;
cache.trial.Timing.TrialTime = cache.trial.Timing.EndTime-cache.trial.Timing.OriginalStartTime;
cache.trial.Timing.ActiveTime = cache.trial.Timing.EndTime-cache.trial.Timing.StartTime;

cache.lists.MetaCondition(end+1) = cache.trial.Conditions.MetaConditionIndex;
cache.lists.OptsMetaCondSegment(end+1) = cache.trial.Conditions.OptsMetaCondSegment;
cache.lists.StopCondition(end+1) = cache.trial.Behavior.StopCondition;
cache.lists.BlockNo(end+1) = cache.trial.Conditions.BlockNo;
cache.lists.BlockIndex(end+1) = cache.trial.Conditions.BlockIndex;
cache.lists.Condition(end+1) = cache.trial.Conditions.Condition;
cache.lists.Group(end+1) = cache.trial.Conditions.RuleImages.Group;
cache.lists.Cue(end+1) = cache.trial.Conditions.RuleImages.Cue;
cache.lists.Stim(end+1) = cache.trial.Conditions.RuleImages.Stim;
cache.lists.NumDistractors(end+1) = cache.trial.Conditions.NumDistractors;
cache.lists.PreDistractors(end+1) = cache.trial.Conditions.PrePostDistractors(1);
cache.lists.PostDistractors(end+1) = cache.trial.Conditions.PrePostDistractors(2);
cache.lists.Response(end+1) = cache.trial.Behavior.Response;
cache.lists.NumRewards(end+1) = cache.trial.Reward.NumRewards;
cache.lists.IdleTime(end+1) = cache.trial.Timing.IdleTime;
cache.lists.ReactionTime(end+1) = cache.trial.Behavior.ReactionTime;
cache.lists.MeanFixPointX(end+1) = cache.trial.Tracking.MeanFixPoint(1);
cache.lists.MeanFixPointY(end+1) = cache.trial.Tracking.MeanFixPoint(2);