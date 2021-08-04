function ObjectListAdd( type , params )

%%% Task - general

%%
global cache

cache.display.Object.Counter = cache.display.Object.Counter+1;
cache.display.Object.List =  [cache.display.Object.List struct('Type', type, 'Priority', cache.display.Object.Counter, 'Parameters', {params})];
