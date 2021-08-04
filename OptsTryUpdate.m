function OptsTryUpdate

%%% Task - general

%%
global specs opts funcOpts optsHistory cache

pre = struct('specs',specs,'opts',opts,'funcOpts',funcOpts,'optsHistory',optsHistory,'cache',cache);

try,
    [tempOpts,tempFuncOpts,loaded] = OptsLoad(opts);
    if loaded & SanityCheck(tempOpts,tempFuncOpts),
        cache.OptsUpdateTrial = cache.TrialNo;
        cache.OptsMetaCondSegment = cache.OptsMetaCondSegment+MetaCondChangeDetect(opts,tempOpts);
        opts = tempOpts;
        funcOpts = tempFuncOpts;
        optsHistory = [optsHistory ...
            struct('opts', opts, 'funcOpts', funcOpts, 'trial', cache.TrialNo, 'time', datevec(now), 'timeSecs', GetSecs)];
    end
catch,
    specs = pre.specs;
    opts = pre.opts;
    funcOpts = pre.funcOpts;
    optsHistory = pre.optsHistory;
    cache = pre.cache;
end