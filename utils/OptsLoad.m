function [ newOpts , newFuncOpts , loaded ] = OptsLoad ( oldOpts )

global specs

loaded = 0;

tempOpts = getfield(load('opts.mat','opts'),'opts');
if ~all(tempOpts.Code.UpdateTimeStamp == oldOpts.Code.UpdateTimeStamp),
	newOpts = tempOpts;
    loaded = 1;
else,
    newOpts = oldOpts;
end
newFuncOpts = InitFuncOpts(newOpts);
