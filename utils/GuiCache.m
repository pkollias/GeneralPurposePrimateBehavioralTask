function GuiCache

%%% Task - specific

%%
global opts cache stats figures

tag = 'cachetext';

delete(findobj(figures.Gui.h,'Tag',tag));

if strcmp(cache.Block.Policy,'size'),
    policytexttrials = sprintf('/%.0f',cache.Block.Size);
    policytextperf = sprintf('');
elseif strcmp(cache.Block.Policy,'criterion'),
    policytexttrials = sprintf('');
    policytextperf = sprintf(' (%.2f)',opts.Conditions.Block.Criterion.Threshold(cache.trial.Conditions.BlockIndex));
end

str = {sprintf('Block Index: %d - %s',cache.trial.Conditions.BlockIndex,cache.Block.Policy) ...
        sprintf('Block Trials: %d/%d%s',stats.CacheStats.AttemptedTrialsInBlock,stats.CacheStats.TrialsInBlock,policytexttrials) ...
        sprintf('Block Performance: %.2f%s',stats.CacheStats.BlockPerf,policytextperf) ...
        strcat(sprintf('Outcome Queue: ... '),sprintf('%d ',stats.CacheStats.StopConditionQueue)) ...
        sprintf('Last Opts Update Trial: %d',cache.OptsUpdateTrial)};

cachetext = uicontrol(figures.Gui.h,'Style','text', ...
                'Tag',tag, ...
                'String',str, ...
                'Position',[940 495 180 160], ...
                'HorizontalAlignment','left', ...
                'FontSize',9);
drawnow;