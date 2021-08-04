function InitFiles

%%% Task - specific

%%
global specs files

%% Images
%%%%%%%%%
for g=1:specs.Task.NumGroups,
    
    for c=1:specs.Task.NumCuesPerGroup,
        files.images.Cue(g,c).FileName = fullfile(specs.Task.ImagesPath,sprintf('%d%d0.jpg',g,c));
        files.images.Cue(g,c).Array = imread(files.images.Cue(g,c).FileName,'JPG');
        files.images.Cue(g,c).Texture = NaN;
    end
    
    for s=1:specs.Task.NumStimPerGroup,
        files.images.Stim(g,s).FileName = fullfile(specs.Task.ImagesPath,sprintf('%d0%d.jpg',g,s));
        files.images.Stim(g,s).Array = imread(files.images.Stim(g,s).FileName,'JPG');
        files.images.Stim(g,s).Texture = NaN;
    end
    
    files.images.NullStim.FileName = fullfile(specs.Task.ImagesPath,'000.jpg');
    files.images.NullStim.Array = imread(files.images.NullStim.FileName,'JPG');
    files.images.NullStim.Texture = NaN;

end