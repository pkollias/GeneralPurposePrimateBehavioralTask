function [ timeout , err_start ] = OutcomeInit( stop_cond )

%%% Task - general

%%
global specs devs opts cache

MessageDisplay(sprintf('%s\n',stop_cond));

Screen('FillRect',devs.wPtr,floor(repmat(specs.Display.Black,1,3)));
Screen('Flip',devs.wPtr);

WaitSecs(20/1000);

WaitSecs(opts.Timing.FeedbackDisplayTime/1000);

Screen('FillRect',devs.wPtr,floor(opts.Display.TimeoutBackground.Color(find(opts.Display.TimeoutBackground.StopCondition == cache.trial.Behavior.StopCondition),:).*specs.Display.White));
Screen('Flip',devs.wPtr);

err_start = GetSecs;

timeout = TimeoutCalculate;