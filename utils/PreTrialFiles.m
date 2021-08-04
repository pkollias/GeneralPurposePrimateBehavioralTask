function PreTrialFiles

%%% Task - specific

%%
global specs devs files

for g=1:specs.Task.NumGroups,
    
    for c=1:specs.Task.NumCuesPerGroup,
        files.images.Cue(g,c).Texture = Screen('MakeTexture',devs.wPtr,double(files.images.Cue(g,c).Array));
    end
    
    for s=1:specs.Task.NumStimPerGroup,
        files.images.Stim(g,s).Texture = Screen('MakeTexture',devs.wPtr,double(files.images.Stim(g,s).Array));
    end
    
end
    
files.images.NullStim.Texture = Screen('MakeTexture',devs.wPtr,double(files.images.NullStim.Array));