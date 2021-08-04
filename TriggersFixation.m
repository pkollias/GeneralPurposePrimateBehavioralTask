if specs.Eyelink.UseEyelink,
    TriggerSendDev(specs.Encodes.START_TRIAL); TriggerSendDev(0);
    Eyelink('message', 'START_TRIAL');
    TriggerSendDev(specs.Encodes.START_TRIAL); TriggerSendDev(0);
    TriggerSendDev(specs.Encodes.START_TRIAL); TriggerSendDev(0);
    TriggerSendDev(specs.Encodes.TRIAL_NUM_OFFSET+cache.TrialNo); %%% pk check if that breaks it down correctly
    TriggerSendDev(0);
    Eyelink('message', sprintf('TRIAL_NUM=%4.0f', cache.TrialNo));
end