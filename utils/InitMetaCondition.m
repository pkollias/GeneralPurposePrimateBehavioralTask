function InitMetaCondition
% Sets MetaConditions for specific experiment. Metaconditions are used in
% an experiment-specific way heavily by other functions in the code to
% guide condition selection per trial

%% MetaCondition
global specs opts

imsfig = figure;
pos = 1;
for g=1:specs.Task.NumGroups,
    
    for c=1:specs.Task.NumCuesPerGroup,
        subplot(specs.Task.NumGroups+1,specs.Task.NumCuesPerGroup+specs.Task.NumStimPerGroup,pos);
        pos = pos+1;
        imshow(imread(fullfile(specs.Task.ImagesPath,sprintf('%d%d0.jpg',g,c)),'JPG'));
    end
    
    for s=1:specs.Task.NumStimPerGroup,
        subplot(specs.Task.NumGroups+1,specs.Task.NumCuesPerGroup+specs.Task.NumStimPerGroup,pos);
        pos = pos+1;
        imshow(imread(fullfile(specs.Task.ImagesPath,sprintf('%d0%d.jpg',g,s)),'JPG'));
    end
    
end

subplot(specs.Task.NumGroups+1,specs.Task.NumCuesPerGroup+specs.Task.NumStimPerGroup,pos);
pos = pos+1;
imshow(imread(fullfile(specs.Task.ImagesPath,'000.jpg'),'JPG'));

%%
nds = [[0 0]; [0 1]];
opts.Conditions.MetaConditionList = {struct('Group', 1, 'Cue', 1, 'Stim', 1, 'NumDistractors', nds), ...
                                     struct('Group', 1, 'Cue', 2, 'Stim', 1, 'NumDistractors', nds), ...
                                     struct('Group', 1, 'Cue', 1, 'Stim', 2, 'NumDistractors', nds), ...
                                     struct('Group', 1, 'Cue', 2, 'Stim', 2, 'NumDistractors', nds), ...
                                     struct('Group', 2, 'Cue', 1, 'Stim', 1, 'NumDistractors', nds), ...
                                     struct('Group', 2, 'Cue', 2, 'Stim', 1, 'NumDistractors', nds), ...
                                     struct('Group', 2, 'Cue', 1, 'Stim', 2, 'NumDistractors', nds), ...
                                     struct('Group', 2, 'Cue', 2, 'Stim', 2, 'NumDistractors', nds)};