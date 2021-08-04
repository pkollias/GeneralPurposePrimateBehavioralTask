function timeout = TimeoutCalculate

%%% Task - general

%%
global opts cache

tovar = randi(opts.Timing.Timeout.Variability);

toindex = find(opts.Timing.Timeout.StopCondition == cache.trial.Behavior.StopCondition);
if isempty(toindex),
    toindex = find(opts.Timing.Timeout.StopCondition == 0);
end
tobaseline = opts.Timing.Timeout.Duration(toindex);

timeout = tobaseline+tovar;

if ismember(cache.trial.Behavior.StopCondition,[opts.Behavior.StopConditionBroken opts.Behavior.StopConditionIncorrect]),
    window = 20;
    sc = cache.lists.StopCondition;
    if ismember(cache.trial.Behavior.StopCondition,[opts.Behavior.StopConditionBroken]),
        inds = find(~ismember(sc,opts.Behavior.StopConditionIdle),window,'last');
        rate = mean(ismember(sc(inds),opts.Behavior.StopConditionBroken));
        tiers =                                [0.00 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 1.00];
        tierbonus = (cache.TrialNo >= 30)*1000*opts.Timing.Timeout.BreakScale*[-2.0 -1.0 +0.5 +1.2 +2.0 +3.2 +4.5 +6.0 +7.5 +8.7 +9.5 +10.0];
    else,
        inds = find(ismember(sc,opts.Behavior.StopConditionAttempted),window,'last');
        rate = mean(ismember(sc(inds),opts.Behavior.StopConditionIncorrect));
        tiers =                                [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 1.00];
        tierbonus = (cache.TrialNo >= 30)*1000*opts.Timing.Timeout.IncScale*[-2.0 -1.0 +0.0 +1.0 +2.0 +2.5 +3.5 +5.0 +5.5 +9.5];
    end
    pos = find(rate <= tiers,1,'first');
    if ~isempty(pos),
        timeout = timeout+(cache.TrialNo > 40)*tierbonus(pos);
    end
end
% if ismember(cache.trial.Behavior.StopCondition,[-3 -7]),
%     stagetostim = [1 reshape(repmat(1:8,2,1),1,[])];
%     breakatstim = stagetostim(cache.trial.Behavior.StageNo);
%     maxstim = 8;
%     timeout = 1.25*(maxstim-breakatstim)*(cache.trial.Timing.Var.StimTime+cache.trial.Timing.Var.StimDelayTime);
% end