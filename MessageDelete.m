function MessageDelete( varargin )

%%% Task - general

%%
global figures

str = get(figures.Gui.Text.h,'String');

if length(varargin) == 1,
    delpos = length(str)-varargin{1}+1;
else,
    delpos = length(str);
end

if delpos > 0,
    str = {str{1:delpos-1}};
end

figures.Gui.Text.String = str;
set(figures.Gui.Text.h,'String',figures.Gui.Text.String);
drawnow;