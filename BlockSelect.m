function index = BlockSelect

%%% Task - general

%%% add blockchangepolicy for criterion for all MCs in block - be very
%%% careful though with probabilistic mc selection because the unlikely
%%% ones should not have the same accuracy threshold as the more likely
%%% ones. Define maybe in same way as metacondprob list. specific
%%% thresholds for each mc in each block

%%
global opts cache
global block_gui

change = 0;

if ~isempty(cache.lists.OptsMetaCondSegment) & cache.trial.Conditions.OptsMetaCondSegment ~= cache.lists.OptsMetaCondSegment(end),

    InitBlockCache;

end

if cache.BlockNo,
    attinds = find(ismember(cache.lists.StopCondition,opts.Conditions.Block.Criterion.StopConditionList) & cache.lists.BlockNo == cache.BlockNo);
    corrinds = find(ismember(cache.lists.StopCondition,opts.Conditions.Block.Criterion.StopConditionCorrect) & cache.lists.BlockNo == cache.BlockNo);
end

if block_gui | ...
  ...
  ~strcmp(cache.Block.Policy,opts.Conditions.Block.ChangePolicy) | ...
  ... 
  (strcmpi(opts.Conditions.Block.ChangePolicy,'size') & ...
  (~cache.BlockNo | isnan(cache.Block.Size) | isempty(cache.Block.Permutation.Perm) | ...
  (numel(find(cache.lists.BlockNo == cache.BlockNo & ismember(cache.lists.StopCondition,opts.Behavior.StopConditionAttempted))) == cache.Block.Size))) | ...
  ...
  (strcmpi(opts.Conditions.Block.ChangePolicy,'criterion') & ...
  (~cache.BlockNo | isempty(cache.Block.Permutation.Perm) |  ...
  (numel(find(cache.lists.BlockNo == cache.BlockNo & ismember(cache.lists.StopCondition,opts.Behavior.StopConditionAttempted))) == cache.Block.Size) | ...
  (~isempty(attinds) & numel(attinds) >= opts.Conditions.Block.Criterion.MinimumTrials & ...
  mean(ismember(attinds(max(1,end-opts.Conditions.Block.Criterion.History+1):end),corrinds)) >= opts.Conditions.Block.Criterion.Threshold(cache.Block.Permutation.Perm(cache.Block.Permutation.Index))))),

        change = 1;
        cache.BlockNo = cache.BlockNo+1;
        
        if block_gui,
            block_gui = 0;
        end

end


if change,
    
    nblocks = size(opts.Conditions.Block.MetaConditionProbList,1);

    if any(strcmpi(opts.Conditions.Block.NextBlockPolicy,{'permutation' 'sequence' 'arbitrary'})),

        permindex = cache.Block.Permutation.Index;
        permindex = mod(permindex,nblocks)+1;
        if permindex == 1,

            if strcmpi(opts.Conditions.Block.NextBlockPolicy,'permutation'),
                cache.Block.Permutation.Perm = randperm(nblocks);
            elseif strcmpi(opts.Conditions.Block.NextBlockPolicy,'sequence'),
                cache.Block.Permutation.Perm = 1:nblocks;
            elseif strcmpi(opts.Conditions.Block.NextBlockPolicy,'arbitrary'),
                cache.Block.Permutation.Perm = opts.Conditions.Block.ArbitrarySequence;
            end

        end
        
        cache.Block.Permutation.Index = permindex;
        index = cache.Block.Permutation.Perm(cache.Block.Permutation.Index);

    elseif strcmpi(opts.Conditions.Block.NextBlockPolicy,'block_bias'),

        cache.Block.Permutation.Index = find(rand < cumsum(opts.Conditions.Block.Bias)./sum(opts.Conditions.Block.Bias),1,'first');
        cache.Block.Permutation.Perm = 1:nblocks;
        index = cache.Block.Permutation.Index;

    end

    if strcmpi(opts.Conditions.Block.ChangePolicy,'size'),

        if size(opts.Conditions.Block.Size,1) == 1,
            pos = 1;
        elseif size(opts.Conditions.Block.Size,1) == nblocks,
            pos = index;
        end
        cache.Block.Size = SetTimeVariable(opts.Conditions.Block.Size(pos,:));

    elseif strcmpi(opts.Conditions.Block.ChangePolicy,'criterion'),

%         cache.Block.Size = NaN;

        if size(opts.Conditions.Block.Size,1) == 1,
            pos = 1;
        elseif size(opts.Conditions.Block.Size,1) == nblocks,
            pos = index;
        end
        cache.Block.Size = SetTimeVariable(opts.Conditions.Block.Size(pos,:));

    end

else,
    
    index = cache.Block.Permutation.Perm(cache.Block.Permutation.Index);
    
end

cache.Block.Policy = opts.Conditions.Block.ChangePolicy;


