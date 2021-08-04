function run_task = TrialStatus

%%% Task - general

%%% Move UseKb stuff to the same part with gui check
%%% take Block_break code and put it anywhere where recording is exiting

%%
global specs devs opts cache

run_task = 1;

if cache.TrialNo >= specs.Task.MaximumTrials,

    if specs.Eyelink.UseEyelink,
        TriggerSendDev(specs.Encodes.BLOCK_BREAK);
        Eyelink('message','BLOCK_BREAK');
        Eyelink('StopRecording');
        WaitSecs(0.1);
    end

    run_task = 0;
end


if opts.Code.UseKb,
    
    [keyIsDown, firstKeyPressTimes] = KbQueueCheck(devs.Kb.KbDeviceIndex);
    if keyIsDown,

        if firstKeyPressTimes(devs.Kb.PauseKey),
            
            PauseRecording;

            Screen('FillRect',devs.wPtr,floor(specs.Display.DefaultBackgroundColor.*specs.Display.White));
            Screen('Flip',devs.wPtr);

            [~, keyCode, ~] = KbWait(devs.Kb.KbDeviceIndex, 2);

            if keyCode(devs.Kb.ExitKey), run_task = 0; end
            KbQueueFlush(devs.Kb.KbDeviceIndex);

            Screen('FillRect',devs.wPtr,floor(specs.Display.DefaultBackgroundColor.*specs.Display.Black));
            Screen('Flip',devs.wPtr);

            ResumeRecording;

            Screen('FillRect',devs.wPtr,floor(specs.Display.DefaultBackgroundColor.*specs.Display.Black));
            Screen('Flip',devs.wPtr);
            KbQueueFlush(devs.Kb.KbDeviceIndex);

        elseif firstKeyPressTimes(devs.Kb.ExitKey),
            fprintf('Exiting\n\n');
            run_task = 0;
        end
    end
    KbQueueFlush(devs.Kb.KbDeviceIndex);
    
end