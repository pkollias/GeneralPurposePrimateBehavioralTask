function InitFigures

%%% Task - specific

%%
global figures

figures.Gui.h = gui;
close(figures.Gui.h);
figures.Gui.h = gui;

figures.Gui.Params.KernSize = 30;
figures.Gui.Params.MinimumTrials = 30;
figures.Gui.Params.StopCond.Codes = [1 -2 -3 -4 -5 -6 -7 -8];
figures.Gui.Params.StopCond.Strings = {'C' 'NF' 'BF' 'NB' 'ERL' 'NR' 'ERS' 'LRL'};
figures.Gui.Params.RTstopcond = [1];

figures.Gui.Text.h = findobj(figures.Gui.h,'Style','text','Tag','trialtext');
figures.Gui.Text.String = {};
set(figures.Gui.Text.h,'FontSize',9);