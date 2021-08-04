function result = CutOff( type , params , rt )

%%% Task - general

%%
if strcmp(type,'sigmoid'),
    result = rand < 1-(1./(1+exp(-params.slope*(rt-params.mean))));
end