function val = SetIncrBoundVariable( nsucc , init , incrsize , incrstep , bound )

%%% Task - general

nincr = floor(nsucc/incrstep);
cur = init+nincr*incrsize;

boundrange = min([max([bound(1,:); cur]); bound(2,:)]);

if length(boundrange) == 1,
    val = boundrange;
elseif length(boundrange) == 2,
    val = randi([boundrange(1) boundrange(2)],1,1);
end