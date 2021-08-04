function time = BehStructStageDurationTime( behstruct , stagename , stageiter , action )

time = NaN;

stageinds = find(strcmpi(stagename,{behstruct(:).StageName}));
if length(stageinds) >= stageiter,
    stage = stageinds(stageiter);
    time = behstruct(stage).(action).EventTime-behstruct(stage).(action).InitTime;
end