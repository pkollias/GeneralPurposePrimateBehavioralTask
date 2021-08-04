function BehActionTerminate ( behstruct , actionlist , beh_result , fail_text )

%%% Task - general

%%
global specs figures

if ~beh_result,

    MessageDisplay(fail_text);

elseif any(strcmpi(actionlist,'FixAcq')),
    
    if ~behstruct.FixAcq.Exclusive,
        MessageDisplay(sprintf('Fixation acquired'));
    else,
        MessageDisplay(sprintf('Saccade acquired (location %d)',behstruct.FixAcq.Choice));
    end
    
end