function behstruct = BehStructAddValue( behstruct , action , varargin )

%%% Task - general

%%
for i=1:2:length(varargin),
    behstruct.(action).(varargin{i}) = varargin{i+1};
end