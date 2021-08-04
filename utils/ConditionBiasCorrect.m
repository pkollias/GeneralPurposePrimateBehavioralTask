function val = ConditionBiasCorrect( vallist , vallevels , varargin )

%%% Task - general

%%
global opts cache

if nargin >= 4,
    condlist = varargin{1};
    cond = varargin{2};
    
    if nargin == 5,
        mode = varargin{3};
    else,
        mode = opts.Conditions.ConditionBias.Function(1);
    end
else,
    condlist = cache.lists.Condition;
    cond = cache.trial.Conditions.Condition;
    mode = opts.Conditions.ConditionBias.Function(1);
end

prct_correct = zeros(1,length(vallevels));
prct_error = zeros(1,length(vallevels));
n = zeros(1,length(vallevels));

for v=1:length(vallevels),
    cur_inds = find(ismember(cache.lists.StopCondition,opts.Conditions.ConditionBias.StopConditionList) & ...
        condlist == cond & 1:cache.TrialNo-1 > cache.TrialNo-opts.Conditions.ConditionBias.HistoryWindow & ...
        cache.lists.OptsMetaCondSegment == cache.trial.Conditions.OptsMetaCondSegment & vallist == vallevels(v), ...
        opts.Conditions.ConditionBias.History,'last');
    if ~isempty(cur_inds),
        prct_correct(v) = mean(ismember(cache.lists.StopCondition(cur_inds),opts.Conditions.ConditionBias.StopConditionCorrect));
    end
    prct_error(v) = 1-prct_correct(v);
    n(v) = length(cur_inds);

end


prct_error = prct_error + opts.Conditions.ConditionBias.Ratio;
choice_prob = zeros(size(prct_error));
if ~sum(prct_error) | ~all(n >= opts.Conditions.ConditionBias.MinimumTrials) | mode == 'r',
    choice_prob = ones(1,length(vallevels))./length(vallevels);
elseif mode == 'l',
    choice_prob = prct_error./sum(prct_error);
elseif mode == 's',
    choice_prob = exp(opts.Conditions.ConditionBias.SoftmaxAlpha*prct_error)./sum(exp(opts.Conditions.ConditionBias.SoftmaxAlpha*prct_error));
elseif mode == 'm',
    choice_prob(prct_error == max(prct_error)) = 1;
end

val = vallevels(find(rand <= cumsum(choice_prob),1,'first'));