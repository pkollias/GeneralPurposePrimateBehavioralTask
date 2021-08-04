function [ result , structresult ] = BehStructResult( behstruct , actionlist )

%%% Task - general

%%
structresult = repmat(struct('Action', NaN, 'Outcome', NaN),1,length(actionlist));

for i=1:length(actionlist),
    
    structresult(i).Action = actionlist{i};
    structresult(i).Outcome = behstruct.(structresult(i).Action).Result;

end

result = all([structresult(:).Outcome]);