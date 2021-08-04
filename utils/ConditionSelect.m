function ConditionSelect

%%% Task - specific

%%
global specs opts cache

%Group, Cue, Stim
mc = cache.trial.Conditions.MetaCondition;
cache.trial.Conditions.RuleImages.Group = mc.Group;
cache.trial.Conditions.RuleImages.Cue = mc.Cue;
cache.trial.Conditions.RuleImages.Stim = mc.Stim;

%Condition
cache.trial.Conditions.Condition = ConditionClassify(cache.trial);

%NumDistractors
numdist = mc.NumDistractors;
ndsrange = sum(numdist);
if ~opts.Conditions.ConditionBias.Control | cache.TrialNo == 1,
    cache.trial.Conditions.NumDistractors = randi(ndsrange);
else,
    if ~any(cache.lists.Condition(cache.lists.OptsMetaCondSegment == cache.trial.Conditions.OptsMetaCondSegment) == cache.trial.Conditions.Condition),
        cache.trial.Conditions.NumDistractors = randi(ndsrange);
    else,
        cache.trial.Conditions.NumDistractors = ConditionBiasCorrect(cache.lists.NumDistractors,ndsrange(1):ndsrange(end));
    end
end

%PrePostDistractors
temp.n = 2;
temp.d = cache.trial.Conditions.NumDistractors;
temp.c = nchoosek(1:temp.d+temp.n-1,temp.n-1);
temp.m = size(temp.c,1);
temp.t = ones(temp.m,temp.d+temp.n-1);
temp.t(repmat((1:temp.m).',1,temp.n-1)+(temp.c-1)*temp.m) = 0;
temp.u = [zeros(1,temp.m);temp.t.';zeros(1,temp.m)];
temp.v = cumsum(temp.u,1);
combs = diff(reshape(temp.v(temp.u==0),temp.n+1,temp.m),1).';
rows = find(arrayfun(@(x) ismember(x,numdist(1,1):numdist(1,2)), combs(:,1)) & arrayfun(@(x) ismember(x,numdist(2,1):numdist(2,2)), combs(:,2)));
row = rows(randi(length(rows)));
prepost = combs(row,:);
cache.trial.Conditions.PrePostDistractors = prepost;

%Sequence, MaskSequence
cache.trial.Conditions.Sequence = zeros(1,cache.trial.Conditions.NumDistractors+2);
cache.trial.Conditions.MaskSequence = zeros(1,cache.trial.Conditions.NumDistractors+2);
prediststimlist = [];
postdiststimlist = [];
prepos = 0;
postpos = 0;
for g=1:specs.Task.NumGroups,
    for s=1:specs.Task.NumStimPerGroup,
        if ~(g == mc.Group),
            prepos = prepos+1;
            prediststimlist(prepos) = GroupImageEncode(specs.Task.NumGroups,specs.Task.NumStimPerGroup,g,s);
        end
        if ~(s == mc.Stim & g == mc.Group),
            postpos = postpos+1;
            postdiststimlist(postpos) = GroupImageEncode(specs.Task.NumGroups,specs.Task.NumStimPerGroup,g,s);
        end
    end
end

prediststimw = ones(1,length(prediststimlist));
postdiststimw = ones(1,length(postdiststimlist));
if opts.Task.NullStimUse,
    prediststimlist(end+1) = 0;
    postdiststimlist(end+1) = 0;
    
    prediststimw(end+1) = 1-opts.Task.NullStimProbPenalty;
    postdiststimw(end+1) = 1-opts.Task.NullStimProbPenalty;
end

seq = zeros(1,cache.trial.Conditions.NumDistractors+2);
prediststimseq = randsample(prediststimlist,cache.trial.Conditions.PrePostDistractors(1),1,prediststimw);
postdiststimseq = randsample(postdiststimlist,cache.trial.Conditions.PrePostDistractors(2),1,postdiststimw);
distposseq = [1:prepost(1) prepost(1)+2:prepost(1)+prepost(2)+1];
stimposseq = [prepost(1)+1 prepost(1)+prepost(2)+2];
seq(distposseq) = [prediststimseq postdiststimseq];
seq(stimposseq) = GroupImageEncode(specs.Task.NumGroups,specs.Task.NumStimPerGroup,mc.Group,mc.Stim);
cache.trial.Conditions.Sequence = seq;

% Delayed Reward %%% pk
cache.trial.Conditions.DelayRewards = rand(1,cache.trial.Conditions.NumDistractors+2) <= opts.Task.DelayRewardProb;