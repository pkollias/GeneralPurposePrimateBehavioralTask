function PreTrialFigures( trial_header )

%%% Task - specific

%%
global specs

MessageInit;

MessageDisplay(trial_header);

if specs.Eyelink.UseEyelink,
    Eyelink('command','clear_screen 0');
end