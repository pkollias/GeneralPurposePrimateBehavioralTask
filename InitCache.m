function InitCache

%%% Task - general

%%
global specs cache

%% General
cache.TrialNo = 0;
cache.BlockNo = 0;
cache.OptsUpdateTrial = 0;
cache.OptsMetaCondSegment = 0;
InitBlockCache;
cache.Photon = NaN;



%% Lists
%%%%%%%%%
InitLists;



%% Trial, Eye, Visual Objects
%%%%%%%%%
InitTrial;