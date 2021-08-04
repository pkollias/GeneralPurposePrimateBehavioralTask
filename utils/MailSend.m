function MailSend

global specs devs opts

if opts.Code.MailSend,
    for i=1:length(devs.Mail.Queue),
        try,
            
            if strcmp(devs.Mail.Queue(i).Recipient,'h'),
                recipient = specs.Mail.HandlerAddress;
            elseif strcmp(devs.Mail.Queue(i).Recipient,'*'),
                recipient = specs.Mail.TeamAddress;
            end
            
            if ~isnan(devs.Mail.Queue(i).Attachment),
                sendmail(recipient,devs.Mail.Queue(i).Title,devs.Mail.Queue(i).Body,devs.Mail.Queue(i).Attachment);
            else,
                sendmail(recipient,devs.Mail.Queue(i).Title,devs.Mail.Queue(i).Body);
            end
            
        end
    end
end

devs.Mail.Queue = [];