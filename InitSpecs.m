function [ wPtr ] = InitSpecs( task , animal , varargin )
% Sets specs defaults for a specific task. Specs is a set of parameters
% that should remain constant during the run of a session and have to do
% with hardware or other fixed values
% You can pass arguments through the varargin. But field has to be a cell
% of strings making up the field path and second value has to be a string.
% e.g. SetOptions_Chunking({'ParallelPort' 'Address'},'hex2dec('DFF8')');


%%
global specs

%% Version
%%%%%%%%%
specs.Version.ScriptRun = task;
specs.Version.Monkey = animal;
specs.Version.DateString = datestr(now,'yymmdd');
specs.Version.DateNum = floor(now);
[specs.Version.SaveFileName specs.Version.EdfFilename specs.Version.DumpFileName] = CreateSaveFile(specs.Version.Monkey,specs.Version.DateString);



%% Eyelink system
%%%%%%%%%
specs.Eyelink.UseEyelink = 1;
specs.Eyelink.DummyEyelink = 0;
specs.Eyelink.RequireFixation = 1;
specs.Eyelink.EyelinkUseEllipse = 1;
specs.Eyelink.EyeUsed = [];
specs.Eyelink.CalibrationMode = 'nobar';



%% Parallel port
%%%%%%%%%
specs.ParallelPort.Address = hex2dec('D010');
specs.ParallelPort.RewardBit = 1;
specs.ParallelPort.BarBit = 7;
specs.ParallelPort.BarBitMask = uint16(bitset(0, specs.ParallelPort.BarBit, 1));



%% Event encoding
%%%%%%%%%
specs.Encodes.START_TRIAL = 1;
specs.Encodes.FIX_ON = 2;
specs.Encodes.FIX_ACQUIRED = 3;
specs.Encodes.HOLD_ON = 4;
specs.Encodes.RELEASE_ON = 5;
specs.Encodes.RELEASE_OFF = 6;
specs.Encodes.BAR_RELEASE = 7;
specs.Encodes.SAMPLE_ON = 8;
specs.Encodes.MASK_ON = 9;
specs.Encodes.DELAY_ON = 10;
specs.Encodes.CUE_ON = 11;
specs.Encodes.TARGET_ON = 12;
specs.Encodes.RESPONSE_ON = 13;
specs.Encodes.FEEDBACK_ON = 14;
specs.Encodes.BAR_ACQUIRED = 15;
specs.Encodes.BAR_RELEASED = 16;
specs.Encodes.COND_SEMAPHORE = 50;
specs.Encodes.VAR_SEMAPHORE = 51;
specs.Encodes.BLOCK_BREAK = 97;
specs.Encodes.TASK_PAUSED = 98;
specs.Encodes.END_TRIAL = 99;
specs.Encodes.CORRECT_TRIAL = 40;
specs.Encodes.INCORRECT_TRIAL = 41;
specs.Encodes.NO_FIX_TRIAL = 42;
specs.Encodes.FIX_BREAK_TRIAL = 43;
specs.Encodes.NO_TOUCH_TRIAL = 44;
specs.Encodes.EARLY_RELEASE_TRIAL = 45;
specs.Encodes.NO_RESPONSE_TRIAL = 46;
specs.Encodes.EARLY_RESPONSE_TRIAL = 47;
specs.Encodes.LATE_RELEASE_TRIAL = 48;
specs.Encodes.TRIAL_NUM_OFFSET = 100;


%% Display
%%%%%%%%%
specs.Display.ScreenDiag = 68.58; %in cm %%% make sure this is accurate
specs.Display.ScreenNumber = 1;
specs.Display.ScreenDelay = 0; %in seconds

% Screen('Preference', 'SkipSyncTests', 1);
AssertOpenGL;
screens=Screen('Screens');
if ~ismember(specs.Display.ScreenNumber, screens), error('Couldn''t find the specified screen'); end
specs.Display.White = WhiteIndex(specs.Display.ScreenNumber);
specs.Display.Black = BlackIndex(specs.Display.ScreenNumber);
specs.Display.DefaultBackgroundColor = [0 0 0];

[wPtr,specs.Display.ScreenRect] = Screen('OpenWindow', specs.Display.ScreenNumber, repmat(specs.Display.Black./255,1,3));
specs.Display.ScreenCenter = [specs.Display.ScreenRect(3)/2 specs.Display.ScreenRect(4)/2];
specs.Display.ScreenWidth = specs.Display.ScreenDiag*cos(atan(specs.Display.ScreenRect(4)/specs.Display.ScreenRect(3))); %in cm
specs.Display.ScreenHeight = specs.Display.ScreenDiag*sin(atan(specs.Display.ScreenRect(4)/specs.Display.ScreenRect(3))); %in cm
specs.Display.ScreenHorizRes = specs.Display.ScreenRect(3)./specs.Display.ScreenWidth; %in pix/cm
specs.Display.ScreenVertRes = specs.Display.ScreenRect(4)./specs.Display.ScreenHeight; %in pix/cm

specs.Display.UsePhoton = 1;
specs.Display.HideTimeoutPhoton = 1;



%% Task and sequencing
%%%%%%%%%
specs.Task.MaximumTrials = 3000;
specs.Task.StageNames = {'FIX_ON' 'CUE_ON' 'SAMPLE_ON' 'MASK_ON' 'DELAY_ON' 'FEEDBACK_ON'};

specs.Task.NumGroups = 2;
specs.Task.NumCuesPerGroup = 2;
specs.Task.NumStimPerGroup = 2;
specs.Task.NumMasksPerImage = 0;

specs.Task.ImagesPath = fullfile(pwd,'images','images');
specs.Task.MasksPath = fullfile(pwd,'images','masks');



%% Code housekeeping
%%%%%%%%%
specs.Code.ExitKey = 'escape';
specs.Code.PauseKey = 'space';
specs.Code.SaveData = 1;
specs.Code.AppendBhvFile = 0; %%% check if it works
specs.Code.TrialsPath = fullfile(pwd,specs.Version.SaveFileName(1:end-4));
import java.lang.*;
specs.Code.AnalysesPath = fullfile('G:\My Drive','Lab','Monkey Behavioral Routines','GeneralExperimentCode','OnlineAnalyses',sprintf('%s.txt',specs.Version.Monkey));
specs.Code.ServerPath = '\\bucket.pni.princeton.edu\buschman\Monkey Behavioral Data';



%% Email
%%%%%%%%%
specs.Mail.SenderAddress = 'labcomp@timbuschman.com';
specs.Mail.SenderPassword = 'buschmanlab';
specs.Mail.HandlerAddress = {'kollias@princeton.edu'};
specs.Mail.TeamAddress = {'kollias@princeton.edu'};

specs.Slack.ChannelString = 'prj_working_memory';
specs.Slack.TokenString = 'xoxb-277413843078-HlDLYg3EQuiQ9oZMtbO79D1E';



%% Triggers
%%%%%%%%%
specs.Triggers.SendTriggers = 1;
specs.Triggers.Duration = 2/1000; %in seconds
specs.Triggers.Nbits = 24;
specs.Triggers.StrobeBit = 17;
specs.Triggers.AvailableCodeBits = 1:16;
specs.Triggers.DevName = 'Dev1';
specs.Triggers.PortNames = {'Port0/Line0:7' 'Port1/Line0:7' 'Port2/Line0:7'};



%% varargin
%%%%%%%%%
if mod(length(varargin), 2) ~= 0, error('Must pass key/value pairs'); end
for i = 1:2:length(varargin),
    fields = varargin{i};
    if iscell(fields),
        nfields = length(fields);
        str = 'specs';
        for j = 1:nfields, str = strcat(str,['.(' ''''],fields{j},['''' ')']); end
        try, eval(sprintf('%s = %s;',str,varargin{i+1})); end
    end
end