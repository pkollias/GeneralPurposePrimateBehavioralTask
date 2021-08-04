function TriggerSendDev(val)

global specs devs

if specs.Triggers.SendTriggers,
    
    pat = false(1,specs.Triggers.Nbits);
    pat([specs.Triggers.AvailableCodeBits specs.Triggers.StrobeBit]) = [de2bi(val,length(specs.Triggers.AvailableCodeBits)) true];
    devs.Daq.Session.outputSingleScan(pat);

    pause(specs.Triggers.Duration);

    devs.Daq.Session.outputSingleScan(false(1,specs.Triggers.Nbits));
    
end