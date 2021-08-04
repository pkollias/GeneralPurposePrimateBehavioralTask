if specs.Eyelink.UseEyelink,
    Eyelink('message', 'END_TASK');
    Eyelink('command', 'close_data_file');
    Eyelink('Shutdown');
end
Screen('CloseAll');
KbQueueStop(devs.Kb.KbDeviceIndex);