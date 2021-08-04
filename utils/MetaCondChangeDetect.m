function change = MetaCondChangeDetect( oldOpts , newOpts )

%%% Task - general

%%
change =  ~isequal(oldOpts.Conditions.MetaConditionList,newOpts.Conditions.MetaConditionList) | ...
  ~isequal(oldOpts.Conditions.Block.MetaConditionProbList,newOpts.Conditions.Block.MetaConditionProbList);