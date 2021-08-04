function failedaction = BehStructResultFailedAction( behstruct_result )

%%
failedaction = NaN;
failedpos = ~[behstruct_result(:).Outcome];
if any(failedpos),
    failedaction = behstruct_result(find(failedpos,1,'first')).Action;
end