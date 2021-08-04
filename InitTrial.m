function InitTrial

%%% Task - specific

%%
global cache

%% Display
%%%%%%%%%
ObjectListInit;



%% Trial
%%%%%%%%%
cache.trial.Timing.OriginalStartTime = NaN;
cache.trial.Timing.StartTime = NaN;
cache.trial.Timing.IdleStartTime = NaN;
cache.trial.Timing.EndTime = NaN;
cache.trial.Timing.IdleTime = NaN;
cache.trial.Timing.TrialTime = NaN;
cache.trial.Timing.ActiveTime = NaN;
cache.trial.Timing.StageTime = [];
cache.trial.Timing.Var.CueTime = NaN;
cache.trial.Timing.Var.CueMaskTime = NaN;
cache.trial.Timing.Var.CueDelayTime = NaN;
cache.trial.Timing.Var.StimTime = NaN;
cache.trial.Timing.Var.StimMaskTime = NaN;
cache.trial.Timing.Var.StimDelayTime = NaN;
                                
cache.trial.Display = NaN;

cache.trial.Task.CutOff = NaN;
cache.trial.Task.ShowFeedback = NaN;
cache.trial.Task.ShowMasks = NaN;

cache.trial.Conditions.BlockNo = NaN;
cache.trial.Conditions.BlockIndex = NaN;
cache.trial.Conditions.MetaConditionProb = NaN;
cache.trial.Conditions.MetaCondition = NaN;
cache.trial.Conditions.MetaConditionIndex = NaN;
cache.trial.Conditions.OptsMetaCondSegment = NaN;
cache.trial.Conditions.RuleImages.Group = NaN;
cache.trial.Conditions.RuleImages.Cue = NaN;
cache.trial.Conditions.RuleImages.Stim = NaN;
cache.trial.Conditions.Sequence = NaN;
cache.trial.Conditions.MaskSequence = NaN;
cache.trial.Conditions.PrePostDistractors = NaN;
cache.trial.Conditions.NumDistractors = NaN;
cache.trial.Conditions.DelayRewards = NaN; % Delayed Reward %%% pk

cache.trial.Behavior.BehStruct = [];
cache.trial.Behavior.StageNo = NaN;
cache.trial.Behavior.ObtainedRewards = NaN; % Delayed Reward %%% pk
cache.trial.Behavior.StopCondition = NaN;
cache.trial.Behavior.Response = NaN;
cache.trial.Behavior.ReactionTime = NaN;

cache.trial.Tracking.FixInitPoint = [NaN NaN];
cache.trial.Tracking.MeanFixPoint = [NaN NaN];
cache.trial.Tracking.FixOffset = [NaN NaN];

cache.trial.Reward.NumRewards = NaN;



%% Eye
%%%%%%%%%
cache.eye.EyeSig = NaN;