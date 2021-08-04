function behstruct = BehStructInit( stage , stagename )

%%% Task - general

%%
global opts

behstruct.Stage = stage;
behstruct.StageName = stagename;

for i = 1:length(opts.Behavior.ActionList),

    action = opts.Behavior.ActionList{i};

    behstruct.(action).Boolean = NaN;
	behstruct.(action).InitTime = NaN;
	behstruct.(action).Duration = NaN;
    behstruct.(action).Result = NaN;
    
    if any(strcmpi(action,{'FixAcq' 'BarAcq' 'FixRing'})),
        behstruct.(action).Event = 0;
    elseif any(strcmpi(action,{'FixHold' 'BarHold'})),
        behstruct.(action).Event = 1;
    end
	behstruct.(action).EventTime = NaN;

    if any(strcmpi(action,{'FixAcq' 'FixHold'})),
        behstruct.(action).Radius = NaN;
        behstruct.(action).Point = NaN;
    end
    
    if any(strcmpi(action,{'FixRing'})),
        behstruct.(action).InnerRadius = NaN;
        behstruct.(action).OuterRadius = NaN;
        behstruct.(action).Point = NaN;
        behstruct.(action).SampleTime = NaN;        
    end
    
    if any(strcmpi(action,{'FixAcq'})),
        behstruct.(action).Exclusive = NaN;
        behstruct.(action).Choice = NaN;
    end

end

behstruct.EyeSig = [];