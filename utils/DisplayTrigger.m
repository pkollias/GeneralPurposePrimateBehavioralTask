function DisplayTrigger( use , screen_delay , code , code_str )

if use,
%     WaitSecs(screen_delay);
    TriggerSendDev(code);
    Eyelink('message', code_str);
end