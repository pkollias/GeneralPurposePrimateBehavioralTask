function OutcomeTerminate( timeout , err_start )

%%% Task - general

%%
global specs devs opts

WaitSecs((timeout-(GetSecs-err_start)*1000)/1000);

Screen('FillRect',devs.wPtr,floor(opts.Display.BackgroundColor.*specs.Display.White));
Screen('Flip',devs.wPtr);