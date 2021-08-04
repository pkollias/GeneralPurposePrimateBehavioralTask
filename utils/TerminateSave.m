%%% Task - general

%%% trials, eyes?

%%
curdir = pwd;
if exist(specs.Code.TrialsPath,'dir'),
    cd(specs.Code.TrialsPath);
    d = dir('*.mat');
    cd(curdir);
    if length(d) == cache.TrialNo,
        rmdir(specs.Code.TrialsPath,'s');
    end
end

if specs.Code.SaveData,
    save(specs.Version.SaveFileName,'specs','devs','opts','funcOpts','optsHistory', ...
                                    'stats','cache','trials','eyes','files');
    set(figures.Gui.h,'PaperUnits','inches','PaperPosition',[0 0 24 18]);
    savefilepath = specs.Version.SaveFileName(1:end-4);
    figh = figures.Gui.h;
    if exist('BehavioralFigure','file'),
        BehavioralFigure;
        figh = figures.behfig;
    end
    saveas(figh,savefilepath,'jpg');
    
    if exist(fullfile(specs.Code.ServerPath,specs.Version.Monkey),'dir'),
        save(fullfile(specs.Code.ServerPath,specs.Version.Monkey,specs.Version.SaveFileName), ...
            'specs','devs','opts','funcOpts','optsHistory', ...
            'stats','cache','trials','eyes','files');
        savefilepath = fullfile(specs.Code.ServerPath,specs.Version.Monkey,specs.Version.SaveFileName(1:end-4));
        saveas(figh,savefilepath,'jpg');
    end
end

if exist(fullfile(specs.Code.AnalysesPath,specs.Version.Monkey),'dir'),
    rmdir(fullfile(specs.Code.AnalysesPath,specs.Version.Monkey),'s');
end