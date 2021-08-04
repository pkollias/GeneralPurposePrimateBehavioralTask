encode = ConditionTriggerEncode;

for codei=1:length(encode),
    TriggerSendDev(encode(codei));
end