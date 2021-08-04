function [ mcond , repeat_last ] = MetaConditionSelect

%%% Task - general

%%
global opts cache

indsMetaCondition = find(cache.trial.Conditions.MetaConditionProb);
repeat_last = 0;

if cache.TrialNo ~= 1 & ...
  ismember(cache.lists.StopCondition(end),opts.Conditions.RepeatErrors.StopConditionList) &  ...
  ~all(cache.lists.MetaCondition(max(1,end-opts.Conditions.RepeatErrors.MaxRepeats+1):end) == cache.lists.MetaCondition(end)) & ...
  cache.trial.Conditions.OptsMetaCondSegment == cache.lists.OptsMetaCondSegment(end),

    repeat_last = rand <= opts.Conditions.RepeatErrors.ProbabilityOfRepeat(find(opts.Conditions.RepeatErrors.StopConditionList == cache.lists.StopCondition(end)));

end

if repeat_last,

    mcond = cache.lists.MetaCondition(end);

else,

    if cache.TrialNo == 1,

        choice_prob = ones(length(indsMetaCondition),1)./length(indsMetaCondition);

    else,
        
        if any(strcmpi(opts.Conditions.Policy,{'random','biased_random','biased_probabilistic'})),
            
            if strcmpi(opts.Conditions.Policy,'biased_probabilistic'),
                gi = find(rand <= cumsum(ProbabilityVector([opts.Conditions.Block.MetaConditionProbGroups(:).Prob])),1,'first');
                indsMetaCondition = intersect(indsMetaCondition,opts.Conditions.Block.MetaConditionProbGroups(gi).Group);
            end

            if any(strcmpi(opts.Conditions.Policy,{'biased_random','biased_probabilistic'})),

                prct_correct = zeros(length(indsMetaCondition),1);
                prct_error = zeros(length(indsMetaCondition),1);
                n = zeros(length(indsMetaCondition),1);
                for i=1:length(indsMetaCondition),
                    mci = indsMetaCondition(i);
                    cur_inds = find(cache.lists.MetaCondition == mci & cache.lists.OptsMetaCondSegment == cache.trial.Conditions.OptsMetaCondSegment & ...
                                    	ismember(cache.lists.StopCondition,opts.Conditions.BiasedRandom.StopConditionList) & 1:cache.TrialNo-1 > cache.TrialNo-opts.Conditions.HistoryWindow, ...
                                        opts.Conditions.History,'last');
                    if ~isempty(cur_inds),
                        prct_correct(i) = mean(ismember(cache.lists.StopCondition(cur_inds),opts.Conditions.BiasedRandom.StopConditionCorrect));
                    end
                    prct_error(i) = 1-prct_correct(i);
                    n(i) = length(cur_inds);
                end
                
                prct_error = prct_error + opts.Conditions.BiasedRandom.Ratio;
                if sum(prct_error) == 0 | ~all(n >= opts.Conditions.BiasedRandom.MinimumTrials),
                    choice_prob = ones(length(indsMetaCondition),1)./length(indsMetaCondition);
                else,
                    choice_prob = prct_error./sum(prct_error);
                end

            elseif strcmpi(opts.Conditions.Policy,'random'),

                choice_prob = ones(length(indsMetaCondition),1)./length(indsMetaCondition);

            end
        elseif strcmpi(opts.Conditions.Policy,'probabilistic'),
            
            choice_prob = cache.trial.Conditions.MetaConditionProb(cache.trial.Conditions.MetaConditionProb > 0);

        end

    end    

	cache.trial.Conditions.MetaConditionProb(indsMetaCondition) = choice_prob;
    mcond = indsMetaCondition(find(rand <= cumsum(choice_prob),1,'first'));

end