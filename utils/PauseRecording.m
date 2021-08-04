if specs.Eyelink.UseEyelink,
    TriggerSendDev(specs.Encodes.TASK_PAUSED);
    Eyelink('message', 'TASK_PAUSED');
    Eyelink('StopRecording');
    WaitSecs(0.1);
end