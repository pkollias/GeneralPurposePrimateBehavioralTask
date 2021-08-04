function PreTrialCache

%%% Task - specific

%%
global specs opts funcOpts cache

cache.TrialNo = cache.TrialNo+1;

cache.Photon = true;

cache.trial.Timing.OriginalStartTime = GetSecs;

cache.trial.Timing.Var.FixTime = SetTimeVariable(opts.Timing.FixTime);
cache.trial.Timing.Var.CueTime = SetTimeVariable(opts.Timing.CueTime);
cache.trial.Timing.Var.CueMaskTime = SetTimeVariable(opts.Timing.CueMaskTime);
cache.trial.Timing.Var.CueDelayTime = SetTimeVariable(opts.Timing.CueDelayTime);
cache.trial.Timing.Var.StimTime = SetTimeVariable(opts.Timing.StimTime);
cache.trial.Timing.Var.StimMaskTime = SetTimeVariable(opts.Timing.StimMaskTime);
cache.trial.Timing.Var.StimDelayTime = SetTimeVariable(opts.Timing.StimDelayTime);

cache.trial.Task.ShowFeedback = SetProbVariable(opts.Task.ShowFeedback);
cache.trial.Task.ShowMasks = SetProbVariable(opts.Task.ShowMasks);

cache.trial.Conditions.OptsMetaCondSegment = cache.OptsMetaCondSegment;
blockindex = BlockSelect;
cache.trial.Conditions.BlockNo = cache.BlockNo;
cache.trial.Conditions.BlockIndex = blockindex;

cache.trial.Conditions.MetaConditionProb = opts.Conditions.Block.MetaConditionProbList(cache.trial.Conditions.BlockIndex,:);
[mcindex,repeat_last] = MetaConditionSelect;
cache.trial.Conditions.MetaConditionIndex = mcindex;
cache.trial.Conditions.MetaCondition = opts.Conditions.MetaConditionList{mcindex};

ConditionSelect;

cache.trial.Behavior.StageNo = 0;

cache.trial.Tracking.FixInitPoint = PointFixInit(opts.Tracking.FixInitFusionWindow,opts.Tracking.FixInitFusionAlpha, ...
            funcOpts.Display.FixRect.Rect_x,funcOpts.Display.FixRect.Rect_y, ...
            cache.TrialNo,cache.lists.MeanFixPointX,cache.lists.MeanFixPointY);

cache.eye.EyeSig = [];