function point = PointTrialTarget( ntargets , xin , yin , offsetin , varargin )

%%% Task - general

%%
offset = zeros(1,2);
if ~any(isnan(offsetin)),
    offset = offsetin;
end

points = [];
for i=1:ntargets,
    x = xin(i);
    y = yin(i);
    points(i,:) = [x y]+offset;
end

if length(varargin) == 1,
    point = points(varargin{1},:);
else,
    point = points;
end