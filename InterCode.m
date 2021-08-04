changepoints = [30 60 120];
if ismember(cache.TrialNo,changepoints),
    pos = find(changepoints == cache.TrialNo);
    if pos == 1,
        nds = [[0 1]; [0 1]];
    elseif pos == 2,
        nds = [[0 1]; [0 2]];
    elseif pos == 3,
        nds = [[0 2]; [0 2]];
    end
    
    
    opts.Conditions.MetaConditionList = {struct('Group', 1, 'Cue', 1, 'Stim', 1, 'NumDistractors', nds), ...
                                         struct('Group', 1, 'Cue', 2, 'Stim', 1, 'NumDistractors', nds), ...
                                         struct('Group', 1, 'Cue', 1, 'Stim', 2, 'NumDistractors', nds), ...
                                         struct('Group', 1, 'Cue', 2, 'Stim', 2, 'NumDistractors', nds), ...
                                         struct('Group', 2, 'Cue', 1, 'Stim', 1, 'NumDistractors', nds), ...
                                         struct('Group', 2, 'Cue', 2, 'Stim', 1, 'NumDistractors', nds), ...
                                         struct('Group', 2, 'Cue', 1, 'Stim', 2, 'NumDistractors', nds), ...
                                         struct('Group', 2, 'Cue', 2, 'Stim', 2, 'NumDistractors', nds)};

    OptsSave(opts);
end

if ismember(cache.TrialNo,[200 400 850 1250]),
    opts.Reward.Pulse = 1.175*opts.Reward.Pulse;
    OptsSave(opts);
end

if ismember(cache.TrialNo,[200 300 500 700 900]),
    opts.Timing.Timeout.BreakScale = opts.Timing.Timeout.BreakScale/1.3;
    OptsSave(opts);
end

if ismember(cache.TrialNo,[300 1000]),
    opts.Reward.StopConditionBonus(1) = opts.Reward.StopConditionBonus(1)+1;
    OptsSave(opts);
end