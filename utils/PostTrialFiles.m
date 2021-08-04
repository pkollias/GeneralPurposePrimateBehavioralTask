function PostTrialFiles

%%% Task - specific

%%
global specs files

for g=1:specs.Task.NumGroups,
    
    for c=1:specs.Task.NumCuesPerGroup,
        Screen('Close',files.images.Cue(g,c).Texture);
        files.images.Cue(g,c).Texture = NaN;
    end
    
    for s=1:specs.Task.NumStimPerGroup,
        Screen('Close',files.images.Stim(g,s).Texture);
        files.images.Stim(g,s).Texture = NaN;
    end
    
end
    
Screen('Close',files.images.NullStim.Texture);
files.images.NullStim.Texture = NaN;