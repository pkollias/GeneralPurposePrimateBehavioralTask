function in = PointInEllipse( point , center , axes )

if axes(1) < axes(2),
    point = point(2:-1:1);
    center = center(:, 2:-1:1);
    axes = axes(2:-1:1);
end

point = repmat(point(:)',[size(center,1) 1]);

f = sqrt(axes(1)^2 - axes(2)^2);

in = (sqrt(sum((point - (center + repmat([f 0],[size(center,1) 1]))).^2,2)) + sqrt(sum((point-(center-repmat([f 0],[size(center,1) 1]))).^2,2)) < (2*axes(1)));