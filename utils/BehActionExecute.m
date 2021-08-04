function behstruct = BehActionExecute( actionlist , behstruct )

%%% Task - general

%%
global specs devs

keepsampling = 1;
hold = struct('fix',1);
eyesig = [];
if any(strcmpi(actionlist,'FixAcq')),
	acq = zeros(size(behstruct.(actionlist{find(strcmpi(actionlist,'FixAcq'))}).Point,1),1);
end

%TJB - added 1/8
if any(strcmpi(actionlist,'FixRing')),
    behstruct.FixRing.Choice = NaN;
    behstruct.FixRing.Event = 0;
    ring_acq = 0;
    ring_vals = [];
end
    
% Initialize Event

while keepsampling,

    % Sample Behavior
    for i=1:length(actionlist),
        
        action = actionlist{i};
        if any(strcmpi(action,{'FixAcq' 'FixHold' 'FixRing'})),
            [mx,my,Tms,pup] = EyelinkGetEyeSample(devs.el,specs.Eyelink.EyeUsed);
            eyesig(:,end+1) = [Tms,mx,my,pup]';
        elseif any(strcmpi(action,{'BarAcq' 'BarHold'})),
            bardown = (bitand(specs.ParallelPort.BarBitMask,io32(devs.ioObj,specs.ParallelPort.Address+1)) > 0);
        end
        
        behstruct.(action).EventTime = GetSecs;

    end

    % Evaluate time
    actiontimeout = zeros(1,length(actionlist));
    for i=1:length(actionlist),

        action = actionlist{i};
        actiontimeout(i) = isnan(behstruct.(action).Duration) | ((GetSecs-behstruct.(action).InitTime)*1000) > behstruct.(action).Duration;

    end
    timeout = all(actiontimeout);

    % Evaluate sample
    actionterminate = zeros(1,length(actionlist));
    for i=1:length(actionlist),

        action = actionlist{i};
        if strcmpi(action,'FixAcq'),
            if ~isnan(mx) & ~isnan(my),
                acq = PointInEllipse([mx my],behstruct.(action).Point,behstruct.(action).Radius);
                behstruct.(action).Choice = find(acq,1,'first');
                if isempty(behstruct.(action).Choice),
                    behstruct.(action).Choice = NaN;
                end
            end
            if any(acq),
                TriggerSendDev(specs.Encodes.FIX_ACQUIRED);
                
                behstruct.(action).Event = 1;
                behstruct.(action).EventTime = GetSecs;
                actionterminate(i)= 1;
            end
        elseif strcmpi(action,'FixHold'),
            hold.fix = ~any(isnan([mx my])) & PointInEllipse([mx my],behstruct.(action).Point,behstruct.(action).Radius);
            if ~hold.fix,
                behstruct.(action).Event = 0;
                behstruct.(action).EventTime = GetSecs;
                actionterminate(i)= 1;
            end
		elseif strcmpi(action, 'FixRing'),
			%TJB - added 1/8
			if ~isnan(mx) && ~isnan(my),
                in_inner = PointInEllipse([mx my], behstruct.(action).Point, behstruct.(action).InnerRadius);
                in_outer = PointInEllipse([mx my], behstruct.(action).Point, behstruct.(action).OuterRadius);
                ring_acq = ~in_inner & in_outer;
                
                if ~in_inner && ~in_outer,
                    %fixated in ring but broke before end of sampling time
                    TriggerSendDev(specs.Encodes.FIX_BREAK_TRIAL);
                    
                    behstruct.(action).Event = 0;
                    behstruct.(action).EventTime = GetSecs;
                    behstruct.(action).Choice = NaN;
                    actionterminate(i)= 1;
                elseif ring_acq,
                    TriggerSendDev(specs.Encodes.FIX_ACQUIRED);
                    behstruct.(action).EventTime = GetSecs;
                    behstruct.(action).Event = 0;
                    behstruct.(action).Choice = NaN;
                    
                    %fixating in ring
                    ring_vals = cat(1, ring_vals, [mx my GetSecs]);
                    if (ring_vals(end, 3) - ring_vals(1, 3)) >= behstruct.(action).SampleTime,
                        %sampled for long enough
                        avg_point = nanmean(ring_vals(:, 1:2), 1) - behstruct.(action).Point;
                        behstruct.(action).Choice = cart2pol(avg_point(2), avg_point(1))/pi*180; %note -- the x/y are flipped because the arcs are relative to vertical axis!
                        
                        behstruct.(action).Event = 1;
                        actionterminate(i)= 1;
                    end
                elseif ~ring_acq && ~isempty(ring_vals),
                    %fixated in ring but broke before end of sampling time
                    TriggerSendDev(specs.Encodes.FIX_BREAK_TRIAL);
                    
                    behstruct.(action).Event = 0;
                    behstruct.(action).EventTime = GetSecs;
                    behstruct.(action).Choice = NaN;
                    actionterminate(i)= 1;
                    ring_vals = [];
                end
            end
        elseif strcmpi(action,'BarAcq'),
            if bardown,
                TriggerSendDev(specs.Encodes.BAR_ACQUIRED);
                
                behstruct.(action).Event = 1;
                behstruct.(action).EventTime = GetSecs;
                actionterminate(i)= 1;
            end
        elseif strcmpi(action,'BarHold'),
            if ~bardown,
                TriggerSendDev(specs.Encodes.BAR_RELEASED);
                
                behstruct.(action).Event = 0;
                behstruct.(action).EventTime = GetSecs;
                actionterminate(i)= 1;
            end
        end

        if ~isnan(behstruct.(action).Event),
            behstruct.(action).Result = ~xor(behstruct.(action).Event,behstruct.(action).Boolean);
        end

    end
    terminate = any(actionterminate);

    % Terminate sampling
    if terminate | timeout,
        keepsampling = 0;
    end

end

if any(strcmpi(actionlist,'FixAcq')),
    behstruct.FixAcq.Exclusive = size(behstruct.FixAcq.Point,1) > 1;
end
behstruct.EyeSig = eyesig;