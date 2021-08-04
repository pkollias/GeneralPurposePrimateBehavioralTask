TriggerSendDev(specs.Encodes.(stop_cond));
if specs.Eyelink.UseEyelink,
    Eyelink('message',stop_cond);
end