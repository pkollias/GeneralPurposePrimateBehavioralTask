function MessageDisplay( varargin )

%%% Task - general

%%
global figures

if ~isempty(varargin{1})

    str = get(figures.Gui.Text.h,'String');
    for i=1:length(varargin),
        str{end+1} = sprintf(varargin{i});
        fprintf('%s\n',varargin{i});
    end

    figures.Gui.Text.String = str;
    set(figures.Gui.Text.h,'String',figures.Gui.Text.String);
    drawnow;

end