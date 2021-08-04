%%% Task - specific

%%
%%% pk gating
% show peripheral cheats
% show feedback
% implement masks
% implement cutoff

%%
% Stagechange - FIX_ON
stagename = 'FIX_ON';
stage = find(strcmpi(stagename,specs.Task.StageNames));
cache.trial.Behavior.StageNo = cache.trial.Behavior.StageNo+1;
% Behavior struct
cache.trial.Behavior.BehStruct = cat(1,cache.trial.Behavior.BehStruct,BehStructInit(stage,stagename));
% Object list
ObjectListInit;
ObjectListAdd('Back',{floor(opts.Display.BackgroundColor.*specs.Display.White)});
ObjectListAdd('Rect',{floor(opts.Display.FrameColor*specs.Display.White) funcOpts.Display.FrameRect.Rect});
ObjectListAdd('Oval',{floor(opts.Display.FixColor*specs.Display.White) funcOpts.Display.FixRect.Rect});


% Housekeeping
cache.trial.Timing.IdleStartTime = GetSecs;

last_attempt = 0;
beh_result = 0;
fail_cond = 0;
stop_cond = 'CORRECT_TRIAL';
while ~last_attempt & ~beh_result,

    % Housekeeping
    cache.trial.Behavior.BehStruct(end) = BehStructInit(stage,stagename);
	stop_cond = 'CORRECT_TRIAL';
    TriggersFixation;
    cache.trial.Timing.StartTime = GetSecs;
    last_attempt = (cache.trial.Timing.StartTime - cache.trial.Timing.IdleStartTime) >= opts.Timing.MaxInitiateTrialTime;
    cache.Photon = true;

    % Display
    ObjectListDisplay;

    % Init BarAcq
    actionlist = FixFilterActionList({'BarAcq'},~specs.Eyelink.RequireFixation);
    if ~isempty(actionlist),
        for actionindex=1:length(actionlist),
            action = actionlist{actionindex};
            actionstagepos = find(strcmpi(cache.trial.Behavior.BehStruct(end).StageName,{opts.Behavior.(action).Stage}));
            switch action,
                case 'BarAcq',
                    cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
                                                                'Duration',opts.Timing.MaxAcquireBarTime, ...
                                                                'Boolean',opts.Behavior.(action)(actionstagepos).Boolean);
            end
        end

        % Execute BarAcq
        cache.trial.Behavior.BehStruct(end) = BehActionExecute(actionlist,cache.trial.Behavior.BehStruct(end));
        cache.eye.EyeSig = cat(2,cache.eye.EyeSig,cache.trial.Behavior.BehStruct(end).EyeSig);

        % Terminate BarAcq
        [beh_result,behstruct_result] = BehStructResult(cache.trial.Behavior.BehStruct(end),actionlist);
        fail_cond = ~beh_result & last_attempt;
        fail_text = [];
        BehActionTerminate(cache.trial.Behavior.BehStruct(end),actionlist,beh_result,fail_text);
        if ~beh_result,
            stop_cond = 'NO_TOUCH_TRIAL';
            continue;
        end
    end

    % Init FixAcq
    actionlist = FixFilterActionList({'FixAcq'},~specs.Eyelink.RequireFixation);
    if ~isempty(actionlist),
        for actionindex=1:length(actionlist),
            action = actionlist{actionindex};
            actionstagepos = find(strcmpi(cache.trial.Behavior.BehStruct(end).StageName,{opts.Behavior.(action).Stage}));
            switch action,
                case 'FixAcq',
                    cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
                                                                'Duration',opts.Timing.MaxAcquireFixTime, ...
                                                                'Boolean',opts.Behavior.(action)(actionstagepos).Boolean, ...
                                                                'Radius',funcOpts.Display.RadiusToPixels(opts.Behavior.(action)(actionstagepos).Radius), ...
                                                                'Point',cache.trial.Tracking.FixInitPoint);
            end
        end

        % Execute FixAcq
        cache.trial.Behavior.BehStruct(end) = BehActionExecute(actionlist,cache.trial.Behavior.BehStruct(end));
        cache.eye.EyeSig = cat(2,cache.eye.EyeSig,cache.trial.Behavior.BehStruct(end).EyeSig);

        % Terminate FixAcq
        [beh_result,behstruct_result] = BehStructResult(cache.trial.Behavior.BehStruct(end),actionlist);
        fail_cond = ~beh_result & last_attempt;
        fail_text = [];
        BehActionTerminate(cache.trial.Behavior.BehStruct(end),actionlist,beh_result,fail_text);
        if ~beh_result,
            stop_cond = 'NO_FIX_TRIAL';
            continue;
        end
    end

    % Housekeeping
    cache.eye.EyeSig = [];
    WaitSecs(opts.Timing.FixGraceTime/1000);

    % Init FixHold, BarHold
    actionlist = FixFilterActionList({'FixHold' 'BarHold'},~specs.Eyelink.RequireFixation);
    if ~isempty(actionlist),
        if specs.Eyelink.RequireFixation,
            inittime = cache.trial.Behavior.BehStruct(end).FixAcq.EventTime;
        else,
            inittime = cache.trial.Behavior.BehStruct(end).BarAcq.EventTime;
        end
        for actionindex=1:length(actionlist),
            action = actionlist{actionindex};
            actionstagepos = find(strcmpi(cache.trial.Behavior.BehStruct(end).StageName,{opts.Behavior.(action).Stage}));
            switch action,
                case 'FixHold',
                    cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                'InitTime',inittime, ...
                                                                'Duration',opts.Timing.FixTime, ...
                                                                'Boolean',opts.Behavior.(action)(actionstagepos).Boolean, ...
                                                                'Radius',funcOpts.Display.RadiusToPixels(opts.Behavior.(action)(actionstagepos).Radius), ...
                                                                'Point',cache.trial.Tracking.FixInitPoint);
                case 'BarHold',
                    cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                'InitTime',inittime, ...
                                                                'Duration',opts.Timing.FixTime, ...
                                                                'Boolean',opts.Behavior.(action)(actionstagepos).Boolean);
            end
        end

        % Execute FixHold, BarHold
        cache.trial.Behavior.BehStruct(end) = BehActionExecute(actionlist,cache.trial.Behavior.BehStruct(end));
        cache.eye.EyeSig = cat(2,cache.eye.EyeSig,cache.trial.Behavior.BehStruct(end).EyeSig);

        % Terminate FixHold, BarHold
        [beh_result,behstruct_result] = BehStructResult(cache.trial.Behavior.BehStruct(end),actionlist);
        fail_cond = ~beh_result & last_attempt;
        fail_text = [];
        BehActionTerminate(cache.trial.Behavior.BehStruct(end),actionlist,beh_result,fail_text);
        if ~beh_result,
            MessageDelete;
            if strcmpi(BehStructResultFailedAction(behstruct_result),'FixHold'),
                stop_cond = 'NO_FIX_TRIAL';
            elseif strcmpi(BehStructResultFailedAction(behstruct_result),'BarHold'),
                stop_cond = 'NO_TOUCH_TRIAL';
            end
            continue;
        else,
            % Housekeeping
            cache.trial.Tracking.MeanFixPoint = PointMeanFix(opts.Tracking.MeanFixWeights,cache.eye.EyeSig);
            cache.trial.Tracking.FixOffset = cache.trial.Tracking.MeanFixPoint - ...
                [funcOpts.Display.FixRect.Rect_x funcOpts.Display.FixRect.Rect_y];
        end
    end
    
end

if fail_cond,
    cache.trial.Timing.StartTime = GetSecs;
    continue;
end





%%
% Stagechange - CUE_ON
if cache.trial.Timing.Var.CueTime > 0,

    stagename = 'CUE_ON';
    stage = find(strcmpi(stagename,specs.Task.StageNames));
    cache.trial.Behavior.StageNo = cache.trial.Behavior.StageNo+1;
    % Behavior struct
    cache.trial.Behavior.BehStruct = cat(1,cache.trial.Behavior.BehStruct,BehStructInit(stage,stagename));
    % Object list
    ObjectListInit;
    ObjectListAdd('Back',{floor(opts.Display.BackgroundColor.*specs.Display.White)});
    ObjectListAdd('Rect',{floor(opts.Display.FrameColor*specs.Display.White) funcOpts.Display.FrameRect.Rect});
    group = cache.trial.Conditions.RuleImages.Group;
    cue = cache.trial.Conditions.RuleImages.Cue;
    rect = funcOpts.Display.CueRect.Rect;
    ObjectListAdd('Texture',{files.images.Cue(group,cue).Texture rect});
    textcenter = [funcOpts.Display.CueRect.Rect_x funcOpts.Display.CueRect.Rect_y];
    textvalue = GroupImageEncode(specs.Task.NumGroups,specs.Task.NumCuesPerGroup,group,cue);
    ObjectListAdd('EyeText',{textcenter textvalue});
    ObjectListAdd('Oval',{floor(opts.Display.FixColor*specs.Display.White) funcOpts.Display.FixRect.Rect});
    point = cache.trial.Tracking.MeanFixPoint;
    ObjectListAdd('EyePoint',{point});
    cache.Photon = ~cache.Photon;
    if cache.Photon,
        ObjectListAdd('Rect',{floor(opts.Display.Photon.Color*specs.Display.White) funcOpts.Display.Photon.Rect});
    end

    % Display
    ObjectListDisplay;

    % Init FixHold, BarHold
    actionlist = FixFilterActionList({'FixHold' 'BarHold'},~specs.Eyelink.RequireFixation);
    if ~isempty(actionlist),
        for actionindex=1:length(actionlist),
            action = actionlist{actionindex};
            actionstagepos = find(strcmpi(cache.trial.Behavior.BehStruct(end).StageName,{opts.Behavior.(action).Stage}));
            switch action,
                case 'FixHold',
                    cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
                                                                'Duration',cache.trial.Timing.Var.CueTime, ...
                                                                'Boolean',opts.Behavior.(action)(actionstagepos).Boolean, ...
                                                                'Radius',funcOpts.Display.RadiusToPixels(opts.Behavior.(action)(actionstagepos).Radius), ...
                                                                'Point',cache.trial.Tracking.MeanFixPoint);
                case 'BarHold',
                    cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
                                                                'Duration',cache.trial.Timing.Var.CueTime, ...
                                                                'Boolean',opts.Behavior.(action)(actionstagepos).Boolean);
            end
        end

        % Execute FixHold, BarHold
        cache.trial.Behavior.BehStruct(end) = BehActionExecute(actionlist,cache.trial.Behavior.BehStruct(end));
        cache.eye.EyeSig = cat(2,cache.eye.EyeSig,cache.trial.Behavior.BehStruct(end).EyeSig);

        % Terminate FixHold, BarHold
        [beh_result,behstruct_result] = BehStructResult(cache.trial.Behavior.BehStruct(end),actionlist);
        fail_cond = ~beh_result;
        fail_text = [];
        BehActionTerminate(cache.trial.Behavior.BehStruct(end),actionlist,beh_result,fail_text);
        if fail_cond,
            if strcmpi(BehStructResultFailedAction(behstruct_result),'FixHold'),
                stop_cond = 'FIX_BREAK_TRIAL';
            elseif strcmpi(BehStructResultFailedAction(behstruct_result),'BarHold'),
                stop_cond = 'EARLY_RESPONSE_TRIAL';
            end
            continue;
        end
    end

end





%%
% % Stagechange - MASK_ON
% if cache.trial.Timing.Var.CueMaskTime > 0 & cache.trial.Task.ShowMasks,
% 
%     stagename = 'MASK_ON';
%     stage = find(strcmpi(stagename,specs.Task.StageNames));
%     cache.trial.Behavior.StageNo = cache.trial.Behavior.StageNo+1;
%     % Behavior struct
%     cache.trial.Behavior.BehStruct = cat(1,cache.trial.Behavior.BehStruct,BehStructInit(stage,stagename));
%     % Object list
%     ObjectListInit;
%     ObjectListAdd('Back',{floor(opts.Display.BackgroundColor.*specs.Display.White)});
%     im = ; %%% pk gating
%     rect = ;
%     ObjectListAdd('Texture',{files.Texture rect});
%     textcenter = ;
%     textvalue = ;
%     ObjectListAdd('EyeText',{textcenter textvalue});
%     ObjectListAdd('Oval',{floor(opts.Display.FixColor*specs.Display.White) funcOpts.Display.FixRect.Rect});
%     point = cache.trial.Tracking.MeanFixPoint;
%     ObjectListAdd('EyePoint',{point});
%     cache.Photon = ~cache.Photon;
%     if cache.Photon
%         ObjectListAdd('Rect',{floor(opts.Display.Photon.Color*specs.Display.White) funcOpts.Display.Photon.Rect});
%     end
% 
%     % Display
%     ObjectListDisplay;
% 
%     % Init FixHold, BarHold
%     actionlist = FixFilterActionList({'FixHold' 'BarHold'},~specs.Eyelink.RequireFixation);
%     if ~isempty(actionlist),
%         for actionindex=1:length(actionlist),
%             action = actionlist{actionindex};
%             actionstagepos = find(strcmpi(cache.trial.Behavior.BehStruct(end).StageName,{opts.Behavior.(action).Stage}));
%             switch action,
%                 case 'FixHold',
%                     cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
%                                                                 'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
%                                                                 'Duration',cache.trial.Timing.Var.CueMaskTime, ...
%                                                                 'Boolean',opts.Behavior.(action)(actionstagepos).Boolean, ...
%                                                                 'Radius',funcOpts.Display.RadiusToPixels(opts.Behavior.(action)(actionstagepos).Radius), ...
%                                                                 'Point',cache.trial.Tracking.MeanFixPoint);
%                 case 'BarHold',
%                     cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
%                                                                 'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
%                                                                 'Duration',cache.trial.Timing.Var.CueMaskTime, ...
%                                                                 'Boolean',opts.Behavior.(action)(actionstagepos).Boolean);
%             end
%         end
% 
%         % Execute FixHold, BarHold
%         cache.trial.Behavior.BehStruct(end) = BehActionExecute(actionlist,cache.trial.Behavior.BehStruct(end));
%         cache.eye.EyeSig = cat(2,cache.eye.EyeSig,cache.trial.Behavior.BehStruct(end).EyeSig);
% 
%         % Terminate FixHold, BarHold
%         [beh_result,behstruct_result] = BehStructResult(cache.trial.Behavior.BehStruct(end),actionlist);
%         fail_cond = ~beh_result;
%         fail_text = [];
%         BehActionTerminate(cache.trial.Behavior.BehStruct(end),actionlist,beh_result,fail_text);
%         if fail_cond,
%             if strcmpi(BehStructResultFailedAction(behstruct_result),'FixHold'),
%                 stop_cond = 'FIX_BREAK_TRIAL';
%             elseif strcmpi(BehStructResultFailedAction(behstruct_result),'BarHold'),
%                 stop_cond = 'EARLY_RESPONSE_TRIAL';
%             end
%             continue;
%         end
%     end
% 
% end





%%
% Stagechange - DELAY_ON
if cache.trial.Timing.Var.CueDelayTime > 0,

    stagename = 'DELAY_ON';
    stage = find(strcmpi(stagename,specs.Task.StageNames));
    cache.trial.Behavior.StageNo = cache.trial.Behavior.StageNo+1;
    % Behavior struct
    cache.trial.Behavior.BehStruct = cat(1,cache.trial.Behavior.BehStruct,BehStructInit(stage,stagename));
    % Object list
    ObjectListInit;
    ObjectListAdd('Back',{floor(opts.Display.BackgroundColor.*specs.Display.White)});
    ObjectListAdd('Rect',{floor(opts.Display.FrameColor*specs.Display.White) funcOpts.Display.FrameRect.Rect});
    ObjectListAdd('Oval',{floor(opts.Display.FixColor*specs.Display.White) funcOpts.Display.FixRect.Rect});
    point = cache.trial.Tracking.MeanFixPoint;
    ObjectListAdd('EyePoint',{point});
    cache.Photon = ~cache.Photon;
    if cache.Photon,
        ObjectListAdd('Rect',{floor(opts.Display.Photon.Color*specs.Display.White) funcOpts.Display.Photon.Rect});
    end

    % Display
    ObjectListDisplay;

    % Init FixHold, BarHold
    actionlist = FixFilterActionList({'FixHold' 'BarHold'},~specs.Eyelink.RequireFixation);
    if ~isempty(actionlist),
        for actionindex=1:length(actionlist),
            action = actionlist{actionindex};
            actionstagepos = find(strcmpi(cache.trial.Behavior.BehStruct(end).StageName,{opts.Behavior.(action).Stage}));
            switch action,
                case 'FixHold',
                    cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
                                                                'Duration',cache.trial.Timing.Var.CueDelayTime, ...
                                                                'Boolean',opts.Behavior.(action)(actionstagepos).Boolean, ...
                                                                'Radius',funcOpts.Display.RadiusToPixels(opts.Behavior.(action)(actionstagepos).Radius), ...
                                                                'Point',cache.trial.Tracking.MeanFixPoint);
                case 'BarHold',
                    cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
                                                                'Duration',cache.trial.Timing.Var.CueDelayTime, ...
                                                                'Boolean',opts.Behavior.(action)(actionstagepos).Boolean);
            end
        end

        % Execute FixHold, BarHold
        cache.trial.Behavior.BehStruct(end) = BehActionExecute(actionlist,cache.trial.Behavior.BehStruct(end));
        cache.eye.EyeSig = cat(2,cache.eye.EyeSig,cache.trial.Behavior.BehStruct(end).EyeSig);

        % Terminate FixHold, BarHold
        [beh_result,behstruct_result] = BehStructResult(cache.trial.Behavior.BehStruct(end),actionlist);
        fail_cond = ~beh_result;
        fail_text = [];
        BehActionTerminate(cache.trial.Behavior.BehStruct(end),actionlist,beh_result,fail_text);
        if fail_cond,
            if strcmpi(BehStructResultFailedAction(behstruct_result),'FixHold'),
                stop_cond = 'FIX_BREAK_TRIAL';
            elseif strcmpi(BehStructResultFailedAction(behstruct_result),'BarHold'),
                stop_cond = 'EARLY_RESPONSE_TRIAL';
            end
            continue;
        end
    end

end





%%
% Housekeeping
fail_cond = 0;
correct = 0;
bar_must_release = 0;
rt_init = NaN;
rt_terminate = NaN;
stimimage = 0;
while stimimage < length(cache.trial.Conditions.Sequence) & ~fail_cond & ~correct,
    
    stimimage = stimimage+1;
    bar_must_release = stimimage == length(cache.trial.Conditions.Sequence);
    
    % Stagechange - SAMPLE_ON
    if cache.trial.Timing.Var.StimTime > 0,

        stagename = 'SAMPLE_ON';
        stage = find(strcmpi(stagename,specs.Task.StageNames));
        cache.trial.Behavior.StageNo = cache.trial.Behavior.StageNo+1;
        % Behavior struct
        cache.trial.Behavior.BehStruct = cat(1,cache.trial.Behavior.BehStruct,BehStructInit(stage,stagename));
        % Object list
        ObjectListInit;
        ObjectListAdd('Back',{floor(opts.Display.BackgroundColor.*specs.Display.White)});
        ObjectListAdd('Rect',{floor(opts.Display.FrameColor*specs.Display.White) funcOpts.Display.FrameRect.Rect});
        [group,stim] = GroupImageDecode(specs.Task.NumGroups,specs.Task.NumStimPerGroup,cache.trial.Conditions.Sequence(stimimage));
        rect = funcOpts.Display.StimRect.Rect;
        if cache.trial.Conditions.Sequence(stimimage),
            ObjectListAdd('Texture',{files.images.Stim(group,stim).Texture rect});
        else,
            ObjectListAdd('Texture',{files.images.NullStim.Texture rect});
        end
        textcenter = [funcOpts.Display.StimRect.Rect_x funcOpts.Display.StimRect.Rect_y];
        textvalue = cache.trial.Conditions.Sequence(stimimage);
        ObjectListAdd('EyeText',{textcenter textvalue});
        ObjectListAdd('Oval',{floor(opts.Display.FixColor*specs.Display.White) funcOpts.Display.FixRect.Rect});
        point = cache.trial.Tracking.MeanFixPoint;
        ObjectListAdd('EyePoint',{point});
        cache.Photon = ~cache.Photon;
        if cache.Photon,
            ObjectListAdd('Rect',{floor(opts.Display.Photon.Color*specs.Display.White) funcOpts.Display.Photon.Rect});
        end

        % Display
        ObjectListDisplay;
        
        % Housekeeping
        rt_init = cache.trial.Timing.StageTime(end).Onset;

        % Init FixHold, BarHold
        actionlist = FixFilterActionList({'FixHold' 'BarHold'},~specs.Eyelink.RequireFixation);
        if ~isempty(actionlist),
            for actionindex=1:length(actionlist),
                action = actionlist{actionindex};
                actionstagepos = find(strcmpi(cache.trial.Behavior.BehStruct(end).StageName,{opts.Behavior.(action).Stage}));
                switch action,
                    case 'FixHold',
                        cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                    'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
                                                                    'Duration',0, ...
                                                                    'Boolean',opts.Behavior.(action)(actionstagepos).Boolean, ...
                                                                    'Radius',funcOpts.Display.RadiusToPixels(opts.Behavior.(action)(actionstagepos).Radius), ...
                                                                    'Point',cache.trial.Tracking.MeanFixPoint);
                    case 'BarHold',
                        cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                    'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
                                                                    'Duration',cache.trial.Timing.Var.StimTime, ...
                                                                    'Boolean',~bar_must_release);
                end
            end

            % Execute FixHold, BarHold
            cache.trial.Behavior.BehStruct(end) = BehActionExecute(actionlist,cache.trial.Behavior.BehStruct(end));
            cache.eye.EyeSig = cat(2,cache.eye.EyeSig,cache.trial.Behavior.BehStruct(end).EyeSig);

            % Terminate FixHold, BarHold
            [beh_result,behstruct_result] = BehStructResult(cache.trial.Behavior.BehStruct(end),actionlist);
            
            % Housekeeping
            if ~cache.trial.Behavior.BehStruct(end).BarHold.Event,
                
                cache.trial.Behavior.Response = stimimage;
                rt_terminate = cache.trial.Behavior.BehStruct(end).BarHold.EventTime;
                cache.trial.Behavior.ReactionTime = rt_terminate - rt_init;
                correct = bar_must_release;
                
                if bar_must_release,
                    early_release_cond = CutOff('sigmoid',struct('mean',opts.Timing.LowerCutoffSigmoidMean,'slope',opts.Timing.CutoffSigmoidSlope),cache.trial.Behavior.ReactionTime);
                    late_release_cond = ~CutOff('sigmoid',struct('mean',opts.Timing.UpperCutoffSigmoidMean,'slope',opts.Timing.CutoffSigmoidSlope),cache.trial.Behavior.ReactionTime);
                    cache.trial.Task.CutOff = early_release_cond | late_release_cond;
                    fail_cond = cache.trial.Task.CutOff;
                    fail_text = [];
                    if early_release_cond,
                        stop_cond = 'EARLY_RELEASE_TRIAL';
                        continue;
                    elseif late_release_cond,
                        stop_cond = 'LATE_RELEASE_TRIAL';
                        continue;
                    end
                end
                
            end
            
            break_fix_cond = (~beh_result & strcmpi(BehStructResultFailedAction(behstruct_result),'FixHold'));
            early_bar_cond = (~beh_result & strcmpi(BehStructResultFailedAction(behstruct_result),'BarHold') & ...
                                ~cache.trial.Behavior.BehStruct(end).BarHold.Event);
            late_bar_cond = (~beh_result & strcmpi(BehStructResultFailedAction(behstruct_result),'BarHold') & ...
                                cache.trial.Behavior.BehStruct(end).BarHold.Event & ...
                                ~(cache.trial.Timing.Var.StimMaskTime > 0 & cache.trial.Task.ShowMasks) & ...
                                ~(cache.trial.Timing.Var.StimDelayTime > 0));
            fail_cond = break_fix_cond | early_bar_cond | late_bar_cond;
            fail_text = [];
            BehActionTerminate(cache.trial.Behavior.BehStruct(end),actionlist,beh_result,fail_text);
            if fail_cond,
                if break_fix_cond,
                    stop_cond = 'FIX_BREAK_TRIAL';
                elseif late_bar_cond,
                    stop_cond = 'NO_RESPONSE_TRIAL';
                elseif early_bar_cond,
                    stop_cond = 'EARLY_RESPONSE_TRIAL';
                end
                continue;
            elseif correct,
                continue;
            end
        end

    end





    %%
    % % Stagechange - MASK_ON
    % if cache.trial.Timing.Var.StimMaskTime > 0 & cache.trial.Task.ShowMasks,
    % 
    %     stagename = 'MASK_ON';
    %     stage = find(strcmpi(stagename,specs.Task.StageNames));
    %     cache.trial.Behavior.StageNo = cache.trial.Behavior.StageNo+1;
    %     % Behavior struct
    %     cache.trial.Behavior.BehStruct = cat(1,cache.trial.Behavior.BehStruct,BehStructInit(stage,stagename));
    %     % Object list
    %     ObjectListInit;
    %     ObjectListAdd('Back',{floor(opts.Display.BackgroundColor.*specs.Display.White)});
    %     im = ; %%% pk gating
    %     rect = ;
    %     ObjectListAdd('Texture',{files.Texture rect});
    %     textcenter = ;
    %     textvalue = ;
    %     ObjectListAdd('EyeText',{textcenter textvalue});
    %     ObjectListAdd('Oval',{floor(opts.Display.FixColor*specs.Display.White) funcOpts.Display.FixRect.Rect});
    %     point = cache.trial.Tracking.MeanFixPoint;
    %     ObjectListAdd('EyePoint',{point});
    % 
    %     % Display
    %     ObjectListDisplay;
    %     cache.Photon = ~cache.Photon;
    %     if cache.Photon,
    %         ObjectListAdd('Rect',{floor(opts.Display.Photon.Color*specs.Display.White) funcOpts.Display.Photon.Rect});
    %     end
    % 
    %     % Init FixHold, BarHold
    %     actionlist = FixFilterActionList({'FixHold' 'BarHold'},~specs.Eyelink.RequireFixation);
    %     if ~isempty(actionlist),
    %         for actionindex=1:length(actionlist),
    %             action = actionlist{actionindex};
    %             actionstagepos = find(strcmpi(cache.trial.Behavior.BehStruct(end).StageName,{opts.Behavior.(action).Stage}));
    %             switch action,
    %                 case 'FixHold',
    %                     cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
    %                                                                 'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
    %                                                                 'Duration',0, ...
    %                                                                 'Boolean',opts.Behavior.(action)(actionstagepos).Boolean, ...
    %                                                                 'Radius',funcOpts.Display.RadiusToPixels(opts.Behavior.(action)(actionstagepos).Radius), ...
    %                                                                 'Point',cache.trial.Tracking.MeanFixPoint);
    %                 case 'BarHold',
    %                     cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
    %                                                                 'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
    %                                                                 'Duration',cache.trial.Timing.Var.StimMaskTime, ...
    %                                                                 'Boolean',~bar_release);
    %             end
    %         end
    % 
    %         % Execute FixHold, BarHold
    %         cache.trial.Behavior.BehStruct(end) = BehActionExecute(actionlist,cache.trial.Behavior.BehStruct(end));
    %         cache.eye.EyeSig = cat(2,cache.eye.EyeSig,cache.trial.Behavior.BehStruct(end).EyeSig);
    % 
    %         % Terminate FixHold, BarHold
    %         [beh_result,behstruct_result] = BehStructResult(cache.trial.Behavior.BehStruct(end),actionlist);
    %     
    %         % Housekeeping
    %         if ~cache.trial.Behavior.BehStruct(end).BarHold.Event,
    % 
    %             cache.trial.Behavior.Response = stimimage;
    %             rt_terminate = cache.trial.Behavior.BehStruct(end).BarHold.EventTime;
    %             cache.trial.Behavior.ReactionTime = rt_terminate - rt_init;
    %             correct = bar_release;
    % 
    %             early_release_cond = CutOff('sigmoid',struct('mean',opts.Timing.LowerCutoffSigmoidMean,'slope',opts.Timing.CutoffSigmoidSlope),cache.trial.Behavior.ReactionTime);
    %             late_release_cond = ~CutOff('sigmoid',struct('mean',opts.Timing.UpperCutoffSigmoidMean,'slope',opts.Timing.CutoffSigmoidSlope),cache.trial.Behavior.ReactionTime);
    %             cache.trial.Task.CutOff = early_release_cond | late_release_cond;
    %             fail_cond = cache.trial.Task.CutOff;
    %             fail_text = [];
    %             if early_release_cond,
    %                 stop_cond = 'EARLY_RELEASE_TRIAL';
    %                 continue;
    %             elseif late_release_cond,
    %                 stop_cond = 'LATE_RELEASE_TRIAL';
    %                 continue;
    %             end
    % 
    %         end
    %
    %         break_fix_cond = (~beh_result & strcmpi(BehStructResultFailedAction(behstruct_result),'FixHold'));
    %         early_bar_cond = (~beh_result & strcmpi(BehStructResultFailedAction(behstruct_result),'BarHold') & ...
    %                             ~cache.trial.Behavior.BehStruct(end).BarHold.Event);
    %         late_bar_cond = (~beh_result & strcmpi(BehStructResultFailedAction(behstruct_result),'BarHold') & ...
    %                             cache.trial.Behavior.BehStruct(end).BarHold.Event & ...
    %                             ~(cache.trial.Timing.Var.StimDelayTime > 0));
    %         fail_cond = break_fix_cond | early_bar_cond | late_bar_cond;
    %         fail_text = [];
    %         BehActionTerminate(cache.trial.Behavior.BehStruct(end),actionlist,beh_result,fail_text);
    %         if fail_cond,
    %             if break_fix_cond,
    %                 stop_cond = 'FIX_BREAK_TRIAL';
    %             elseif late_bar_cond,
    %                 stop_cond = 'NO_RESPONSE_TRIAL';
    %             elseif early_bar_cond,
    %                 stop_cond = 'EARLY_RESPONSE_TRIAL';
    %             end
    %             continue;
    %         elseif correct,
    %             continue;
    %         end
    %     end
    % 
    % end





    %%
    % Stagechange - DELAY_ON
    if cache.trial.Timing.Var.StimDelayTime > 0,

        stagename = 'DELAY_ON';
        stage = find(strcmpi(stagename,specs.Task.StageNames));
        cache.trial.Behavior.StageNo = cache.trial.Behavior.StageNo+1;
        % Behavior struct
        cache.trial.Behavior.BehStruct = cat(1,cache.trial.Behavior.BehStruct,BehStructInit(stage,stagename));
        % Object list
        ObjectListInit;
        ObjectListAdd('Back',{floor(opts.Display.BackgroundColor.*specs.Display.White)});
        ObjectListAdd('Rect',{floor(opts.Display.FrameColor*specs.Display.White) funcOpts.Display.FrameRect.Rect});
        ObjectListAdd('Oval',{floor(opts.Display.FixColor*specs.Display.White) funcOpts.Display.FixRect.Rect});
        point = cache.trial.Tracking.MeanFixPoint;
        ObjectListAdd('EyePoint',{point});
        cache.Photon = ~cache.Photon;
        if cache.Photon,
            ObjectListAdd('Rect',{floor(opts.Display.Photon.Color*specs.Display.White) funcOpts.Display.Photon.Rect});
        end

        % Display
        ObjectListDisplay;

        % Init FixHold, BarHold
        actionlist = FixFilterActionList({'FixHold' 'BarHold'},~specs.Eyelink.RequireFixation);
        if ~isempty(actionlist),
            for actionindex=1:length(actionlist),
                action = actionlist{actionindex};
                actionstagepos = find(strcmpi(cache.trial.Behavior.BehStruct(end).StageName,{opts.Behavior.(action).Stage}));
                switch action,
                    case 'FixHold',
                        cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                    'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
                                                                    'Duration',0, ...
                                                                    'Boolean',opts.Behavior.(action)(actionstagepos).Boolean, ...
                                                                    'Radius',funcOpts.Display.RadiusToPixels(opts.Behavior.(action)(actionstagepos).Radius), ...
                                                                    'Point',cache.trial.Tracking.MeanFixPoint);
                    case 'BarHold',
                        cache.trial.Behavior.BehStruct(end) = BehStructAddValue(cache.trial.Behavior.BehStruct(end),action, ...
                                                                    'InitTime',cache.trial.Timing.StageTime(end).Onset, ...
                                                                    'Duration',cache.trial.Timing.Var.StimDelayTime, ...
                                                                    'Boolean',~bar_must_release);
                end
            end

            % Execute FixHold, BarHold
            cache.trial.Behavior.BehStruct(end) = BehActionExecute(actionlist,cache.trial.Behavior.BehStruct(end));
            cache.eye.EyeSig = cat(2,cache.eye.EyeSig,cache.trial.Behavior.BehStruct(end).EyeSig);

            % Terminate FixHold, BarHold
            [beh_result,behstruct_result] = BehStructResult(cache.trial.Behavior.BehStruct(end),actionlist);
            
            % Housekeeping
            if ~cache.trial.Behavior.BehStruct(end).BarHold.Event,
                cache.trial.Behavior.Response = stimimage;
                rt_terminate = cache.trial.Behavior.BehStruct(end).BarHold.EventTime;
                cache.trial.Behavior.ReactionTime = rt_terminate - rt_init;
                correct = bar_must_release;
                
                if bar_must_release,
                    early_release_cond = CutOff('sigmoid',struct('mean',opts.Timing.LowerCutoffSigmoidMean,'slope',opts.Timing.CutoffSigmoidSlope),cache.trial.Behavior.ReactionTime);
                    late_release_cond = ~CutOff('sigmoid',struct('mean',opts.Timing.UpperCutoffSigmoidMean,'slope',opts.Timing.CutoffSigmoidSlope),cache.trial.Behavior.ReactionTime);
                    cache.trial.Task.CutOff = early_release_cond | late_release_cond;
                    fail_cond = cache.trial.Task.CutOff;
                    fail_text = [];
                    if early_release_cond,
                        stop_cond = 'EARLY_RELEASE_TRIAL';
                        continue;
                    elseif late_release_cond,
                        stop_cond = 'LATE_RELEASE_TRIAL';
                        continue;
                    end
                end
            end
            
            break_fix_cond = (~beh_result & strcmpi(BehStructResultFailedAction(behstruct_result),'FixHold'));
            early_bar_cond = (~beh_result & strcmpi(BehStructResultFailedAction(behstruct_result),'BarHold') & ...
                                ~cache.trial.Behavior.BehStruct(end).BarHold.Event);
            late_bar_cond = (~beh_result & strcmpi(BehStructResultFailedAction(behstruct_result),'BarHold') & ...
                                cache.trial.Behavior.BehStruct(end).BarHold.Event);
            fail_cond = break_fix_cond | early_bar_cond | late_bar_cond;
            fail_text = [];
            BehActionTerminate(cache.trial.Behavior.BehStruct(end),actionlist,beh_result,fail_text);
            
            % Delayed Reward %%% pk
            if ~fail_cond & cache.trial.Conditions.DelayRewards(stimimage),
                cache.trial.Behavior.ObtainedRewards(stimimage) = 1;
                RewardDeliver(specs.ParallelPort.Address,specs.ParallelPort.RewardBit,devs.ioObj,opts.Task.DelayRewardDrops,opts.Reward.Pulse,opts.Reward.InterRewardDelay);
            end
            
            if fail_cond,
                if break_fix_cond,
                    stop_cond = 'FIX_BREAK_TRIAL';
                elseif late_bar_cond,
                    stop_cond = 'NO_RESPONSE_TRIAL';
                elseif early_bar_cond,
                    stop_cond = 'EARLY_RESPONSE_TRIAL';
                end
                continue;
            elseif correct,
                continue;
            end
        end

    end
    
end