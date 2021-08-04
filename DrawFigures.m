function DrawFigures

%%% Task - specific

%%
global opts funcOpts stats cache figures

if cache.TrialNo > figures.Gui.Params.MinimumTrials,
    
    %% Init
    sm_kern = ones(1,figures.Gui.Params.KernSize);
    sm_kern = sm_kern./sum(sm_kern);
    
    
    %% figPerf
    h = findobj(figures.Gui.h,'Tag','figPerf');
    hold(h,'on');
    cla(h);
    
    leg_str = {};
    uniq_resp = unique(cache.lists.StopCondition);
    uniq_resp = sort(uniq_resp,'descend');
    col = hsv(length(uniq_resp));
    for i=1:length(uniq_resp),
        p = plot(h,convn(cache.lists.StopCondition == uniq_resp(i),sm_kern,'valid'),'Color',col(i,:));
        if ~isempty(p),
            leg_str = cat(1,leg_str,figures.Gui.Params.StopCond.Strings{find(figures.Gui.Params.StopCond.Codes == uniq_resp(i))});
        end
    end
    legend(h,leg_str,'Location','northwest');
    set(h,'YLim',[0 1]);
    
    blockpoints = arrayfun(@(x) max(0,find(cache.lists.BlockNo == x,1,'first')-figures.Gui.Params.KernSize), 1:cache.BlockNo);
    for i=1:length(blockpoints),
        plot(h,[blockpoints(i) blockpoints(i)],[0 1],'Color','k');
    end
    
    hold(h,'off');
    drawnow;
    
    
    %% figPerfNDs
    h = findobj(figures.Gui.h,'Tag','figPerfNDs');
    hold(h,'on');
    cla(h);
    
    prerange = unique(cache.lists.PreDistractors);
    postrange = unique(cache.lists.PostDistractors);
    ndperf = nan(length(prerange),length(postrange));
    ndbf = nan(length(prerange),length(postrange));
    for prei=1:length(prerange),
        for posti=1:length(postrange),
            pre = prerange(prei);
            post = postrange(posti);
            inds = ismember(cache.lists.StopCondition,opts.Behavior.StopConditionAttempted) & ...
                                    cache.lists.PreDistractors == pre & cache.lists.PostDistractors == post;
            ndperf(prei,posti) = mean(ismember(cache.lists.StopCondition(inds),opts.Behavior.StopConditionCorrect));
            
            indsbf = ~ismember(cache.lists.StopCondition,opts.Behavior.StopConditionIdle) & ...
                                    cache.lists.PreDistractors == pre & cache.lists.PostDistractors == post;
            ndbf(prei,posti) = mean(ismember(cache.lists.StopCondition(indsbf),opts.Behavior.StopConditionBroken));
        end
    end
    imagesc(ndperf,'Parent',h);
    colorbar;
    for prei=1:length(prerange),
        for posti=1:length(postrange),
            pre = prerange(prei);
            post = postrange(posti);
%             text(posti-.2,prei,sprintf('%.2f',ndperf(prei,posti)), ...
%                     'Color',[0 0 0],'FontSize',7,'Parent',h);
            text(posti-.4,prei,sprintf('%.2f (%.2f) - %d/%d/%d',ndperf(prei,posti),ndbf(prei,posti), ...
                    sum(ismember(cache.lists.StopCondition,opts.Behavior.StopConditionCorrect) & cache.lists.PreDistractors == pre & cache.lists.PostDistractors == post), ...
                    sum(ismember(cache.lists.StopCondition,opts.Behavior.StopConditionAttempted) & cache.lists.PreDistractors == pre & cache.lists.PostDistractors == post), ...
                    sum(~ismember(cache.lists.StopCondition,opts.Behavior.StopConditionIdle) & cache.lists.PreDistractors == pre & cache.lists.PostDistractors == post)), ...
                    'Color',[0 0 0],'FontSize',7,'Parent',h);
        end
    end
    prelabels = {};
    postlabels = {};
    for prei=1:length(prerange),
        prelabels{end+1} = sprintf('%d',prerange(prei));
    end
    for posti=1:length(postrange),
        postlabels{end+1} = sprintf('%d',postrange(posti));
    end
    set(h,'Ytick',1:length(prerange),'YTickLabel',prelabels);
    set(h,'Xtick',1:length(postrange),'XTickLabel',postlabels);
    
    
    hold(h,'off');
    drawnow;

    
    %% figRT
    h = findobj(figures.Gui.h,'Tag','figRT');
    hold(h,'on');
    cla(h);
    
    rt_trials = find(ismember(cache.lists.StopCondition,figures.Gui.Params.RTstopcond));
    plot(h,convn(rt_trials,sm_kern,'valid'),convn(cache.lists.ReactionTime(rt_trials),sm_kern,'valid'));
    
    hold(h,'off');
    drawnow;
    
    
    %% figIdle
    h = findobj(figures.Gui.h,'Tag','figIdle');
    hold(h,'on');
    cla(h);
    
    itime = cache.lists.IdleTime;
    plot(h,itime/60);
    axis(h,[1 length(itime) -.5 opts.Timing.MaxAcquireFixTime/60000+.5]);
    
    hold(h,'off');
    drawnow;
    
    
    %% figMCond
    h = findobj(figures.Gui.h,'Tag','figMCond');
    hold(h,'on');
    cla(h);
    
    cond_list = cache.lists.MetaCondition;
    curoptssegment = cache.lists.OptsMetaCondSegment == cache.trial.Conditions.OptsMetaCondSegment;
    sc_list = cache.lists.StopCondition;
    nconds = size(opts.Conditions.MetaConditionList,2);
    ncodes = length(figures.Gui.Params.StopCond.Codes);
    cond_beh = zeros(nconds,ncodes);
    for i= 1:nconds,
        for j=1:ncodes,
            cond_beh(i,j) = sum(sc_list(cond_list == i & curoptssegment) == figures.Gui.Params.StopCond.Codes(j));
        end
    end
    cond_beh = cond_beh./repmat(sum(cond_beh,2),[1 ncodes]);
    if size(cond_beh,1) > 1,
        bar(h,1:nconds,cond_beh,'stacked');
        legend(h,figures.Gui.Params.StopCond.Strings,'Location','EastOutside');
    end
    
    hold(h,'off');
    drawnow;
    
    
end

%% Stats
GuiStats;
GuiCache;