function point = PointFixInit( window , alphain , rect_x , rect_y , trialno , mean_x , mean_y )

%%% Task - general

%%
if trialno ~= 1,

    coordsRange = max(trialno-window,1):trialno-1;
    coordsHistory = [mean_x(coordsRange); ...
            mean_y(coordsRange)];

    if isempty(coordsHistory) | all(isnan(coordsHistory)),
        alpha = 1;
        coordsHistory = [0 0]';
    else,
        alpha = alphain;
        coordsHistory = mean(coordsHistory(:,find(all(~isnan(coordsHistory)))),2);
    end
    point = alpha*[rect_x rect_y] + (1-alpha)*coordsHistory';

else,

    point = [rect_x rect_y];

end