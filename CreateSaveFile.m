function [ out , varargout ] = CreateSaveFile( monkey , date )

%%% Task - general

%%
out = fullfile('data',sprintf('%s_%s_00_bhv.mat', monkey,date));
if nargout > 1,
    varargout{1} = sprintf('%s%s00.edf', monkey(1),date(2:end));
    varargout{2} = fullfile('data',sprintf('%s_%s_00_bhv_ERROR.mat', monkey,date));
end
count = 0;
while exist(out,'file') & (count < 100),
    count = count+1;
    out = fullfile('data',sprintf('%s_%s_%02.0f_bhv.mat', monkey,date,count));
    if nargout > 1,
        varargout{1} = sprintf('%s%s%02.0f.edf', monkey(1), date(2:end), count);
        varargout{2} = fullfile('data',sprintf('%s_%s_%02.0f_bhv_ERROR.mat', monkey,date,count));
    end
end
if count >= 100,
	error(sprintf('\nError(CreateSaveFile): Couldn''t find a unique filename\n'));
end