function point = PointMeanFix( weights , eye_sig )

%%% Task - general

%%
if isempty(eye_sig),
    point = [NaN NaN];
else,
    if weights == 'l',

        weights = [1:size(eye_sig,2)]/sum(1:size(eye_sig,2));
        x = sum(eye_sig(2,:).*weights);
        y = sum(eye_sig(3,:).*weights);
        
    elseif weights == 's',

        siz = [1:size(eye_sig,2)].^2;
        weights = (siz/sum(siz));
        x = sum(eye_sig(2,:).*weights);
        y = sum(eye_sig(3,:).*weights);

    else,

        x = mean(eye_sig(2,:));
        y = mean(eye_sig(3,:));

    end

    point = [x y];
    if isempty(point),
        point = [NaN NaN];
    end
end