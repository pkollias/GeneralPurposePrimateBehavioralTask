function nr = RewardCalculate

%%% Task - general

%%
global opts cache

stop_cond = cache.trial.Behavior.StopCondition;
sc = [cache.lists.StopCondition stop_cond];

scindex = find(opts.Reward.StopCondition == stop_cond);
scprob = rand < opts.Reward.ProbabilityReward(scindex);
if isempty(scindex),

    drops = 0;
    scprob = 0;

elseif rand < opts.Reward.JackpotChance,

    drops = opts.Reward.Jackpot;

else,

    baseline = opts.Reward.Baseline;
    
    stimbonusv = [2 3 4 5 7];
    stimbonus = stimbonusv(cache.trial.Conditions.NumDistractors+1);

    scbonus = 0;
    if ~isempty(scindex),
        scbonus = opts.Reward.StopConditionBonus(scindex);
    end

    tbonus = 0;
    tierhistoryinds = find(ismember(sc,opts.Reward.StopConditionList),opts.Reward.History,'last');
    if numel(tierhistoryinds) >= opts.Reward.History,
        randsampleinds = randperm(opts.Reward.History,opts.Reward.RandomSample);
        tierhistoryinds = tierhistoryinds(sort(randsampleinds));
        rewhistperf = sum(arrayfun(@(x,y) opts.Reward.StopConditionWeight(y)*mean(sc(tierhistoryinds) == x),opts.Reward.StopConditionList,1:length(opts.Reward.StopConditionList)));
        rewtier = find(opts.Reward.Tiers <= rewhistperf,1,'last');
        tbonus = opts.Reward.TierBonus(rewtier);
    end

    incrbonus = 0;
    ncorr = sum(ismember(sc,opts.Reward.StopConditionCorrect))+opts.Reward.NumCorrectJumpstart;
    incrbonus = floor(ncorr/opts.Reward.IncrementStep)*opts.Reward.IncrementSize;

    drops = baseline+scbonus+tbonus+incrbonus+stimbonus;

end

nr = scprob*drops;
if isempty(nr),
    nr = NaN;
end