function InitDevs( wPtr )

%%% Task - general

%%% Make calibration choice task-specific with specs parameter

%%
global specs devs

%% Parallel port init
% %%%%%%%%%
devs.ioObj = io32;
status = io32(devs.ioObj);
if status ~= 0,
    error(sprintf('\nError(InitDevs): Couldn''t initialize port\n'));
end

data_in = io32(devs.ioObj, specs.ParallelPort.Address);
base_data_out = bitset(data_in, specs.ParallelPort.RewardBit, 0);
io32(devs.ioObj, specs.ParallelPort.Address, base_data_out);



%% Keyboard and mouse init
%%%%%%%%%
KbName('UnifyKeyNames');
devs.Kb.KbDeviceIndex = [];

devs.Kb.ExitKey = KbName(specs.Code.ExitKey);
devs.Kb.PauseKey = KbName(specs.Code.PauseKey);
devs.Kb.KeysOfInterest=zeros(1,256);
devs.Kb.KeysOfInterest([devs.Kb.ExitKey devs.Kb.PauseKey])=1;

KbQueueCreate(devs.Kb.KbDeviceIndex, devs.Kb.KeysOfInterest);
KbQueueStart(devs.Kb.KbDeviceIndex);

HideCursor;
ShowCursor;



%% Eyelink init
%%%%%%%%%
devs.wPtr = wPtr;
InitEyelink;



%% Email init
%%%%%%%%%

setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','E_mail',specs.Mail.SenderAddress);
setpref('Internet','SMTP_Username',specs.Mail.SenderAddress);
setpref('Internet','SMTP_Password',specs.Mail.SenderPassword);
devs.Mail.Props = java.lang.System.getProperties;
devs.Mail.Props.setProperty('mail.smtp.auth','true');
devs.Mail.Props.setProperty('mail.smtp.port','587');
devs.Mail.Props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
devs.Mail.Props.setProperty('mail.smtp.socketFactory.port','465');
devs.Mail.Queue = [];



%% Recording Init
%%%%%%%%%

if specs.Triggers.SendTriggers,
    devs.Daq.Session = daq.createSession('ni');
    devs.Daq.Port32 = devs.Daq.Session.addDigitalChannel ...
                (specs.Triggers.DevName, ...
                specs.Triggers.PortNames, ...
                'OutputOnly');
end