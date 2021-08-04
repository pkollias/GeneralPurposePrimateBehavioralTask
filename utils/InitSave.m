%%% Task - general

%%% Save trial and eye or reconstruct at end of experiment

%%
OptsSave(opts);

dayfiles = dir(sprintf('%s_%s_*_bhv.mat',specs.Version.Monkey,specs.Version.DateString));
if ~isempty(dayfiles) & specs.Code.AppendBhvFile,
    load(dayfiles(end).name,'cache','trials','eyes');
end

mkdir(specs.Code.TrialsPath);

if specs.Code.SaveData,
    save(specs.Version.SaveFileName,'specs','devs','opts','funcOpts','optsHistory', ...
                                    'stats','cache','trials','eyes');
    saveas(figures.Gui.h,specs.Version.SaveFileName(1:end-4),'fig');
end