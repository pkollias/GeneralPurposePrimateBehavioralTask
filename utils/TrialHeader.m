function trial_header = TrialHeader

%%% Task - specific

%%
global cache

trial_header = [sprintf('\nG%d C%d S%d - [ ',cache.trial.Conditions.RuleImages.Group, cache.trial.Conditions.RuleImages.Cue, cache.trial.Conditions.RuleImages.Stim) ...
        sprintf('%d ',cache.trial.Conditions.Sequence) ...
        sprintf(']')];