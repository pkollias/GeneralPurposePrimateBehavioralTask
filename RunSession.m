function [ varargout ] = RunSession ( task , animal )

%% initialize code
clearvars -global specs devs opts funcOpts optsHistory stats files cache figures
clearvars -global exit_gui pause_gui kb_gui calib_gui
global specs devs opts funcOpts optsHistory stats files cache figures
global exit_gui pause_gui kb_gui block_gui calib_gui

sca; close all; clc; %clear all;
import java.lang.*;
cd(fullfile(char(System.getProperty('user.home')),'Documents','MATLAB',animal,task));
rmpath(genpath(fullfile('G:\My Drive','Lab','Monkey Behavioral Routines','GeneralExperimentCode')));
addpath(genpath(fullfile('G:\My Drive','Lab','Monkey Behavioral Routines','GeneralExperimentCode','General')));
addpath(genpath(fullfile('G:\My Drive','Lab','Monkey Behavioral Routines','GeneralExperimentCode','io_config')));
addpath(fullfile('G:\My Drive','Lab','Monkey Behavioral Routines','GeneralExperimentCode',task));
addpath(fullfile('G:\My Drive','Lab','Monkey Behavioral Routines','GeneralExperimentCode',task,animal));
rng('shuffle');

%% data
wPtr = InitSpecs(task,animal);
InitDevs(wPtr);
InitOpts;
funcOpts = InitFuncOpts(opts);
optsHistory = [struct('opts', opts, 'funcOpts', funcOpts, 'trial', 0, 'time', datevec(now), 'timeSecs', GetSecs)];
InitStats;


%% files
InitFiles;


%% bhv
trials = [];
eyes = [];


%% cache
InitCache;


%% figures
InitFigures;


%% Sanity check
if ~SanityCheck(opts,funcOpts),
    sca; close all
    error('Sanity check failed');
end


%% save
InitSave;


%% start recording eye position
InitRecording;
KbQueueFlush(devs.Kb.KbDeviceIndex);


%% deliver initial reward
RewardDeliver(specs.ParallelPort.Address,specs.ParallelPort.RewardBit,devs.ioObj,7,40,100);


%% loop
run_task = 1;
run = 1;
exit_gui = 0;
pause_gui = 0;
kb_gui = 0;
block_gui = 0;
calib_gui = 0;

while run,
    
    % Previous trial outcome
    try,
        if ~specs.Code.AppendBhvFile & cache.TrialNo,

            if specs.Eyelink.UseEyelink,
                Eyelink('command','clear_screen 0');
            end

            cache.trial.Behavior.StopCondition = specs.Encodes.CORRECT_TRIAL-specs.Encodes.(stop_cond)+(specs.Encodes.(stop_cond) == specs.Encodes.CORRECT_TRIAL);

            TriggersOutcome;

            [timeout,err_start] = OutcomeInit(stop_cond);

            PostTrialReward;

            PostTrialFiles;

            PostTrialCache;

            PostTrialStats;
            
            PostTrialAnalysesFile;
            
            PostTrialMail;

            trials = [trials cache.trial];
            cache.eye.EyeSig = single(cache.eye.EyeSig);
            eyes = [eyes cache.eye];

            DrawFigures;

            trial = cache.trial;
            save(fullfile(specs.Code.TrialsPath,sprintf('trial_%.3d.mat',cache.TrialNo)),'trial');
            %%% save analyses text file

            OutcomeTerminate(timeout,err_start);

            % Check for pause or end of session
            [run_task] = TrialStatus;

            if pause_gui | kb_gui | calib_gui,

                if calib_gui,
                    InitEyelink;
                    calib_gui = 0;
                end
                
                if kb_gui,
                    keyboard; %%% make that a button that stops at same point
                    kb_gui = 0;
                end

                PauseRecording;
                while pause_gui & ~exit_gui,
                    WaitSecs(0.5);
                    drawnow;
                end
                ResumeRecording;
            end

            terminateconds = eval(opts.Code.TerminateConditions);
            if ~run_task | exit_gui | terminateconds,
                run = 0;
                break;
            end

        end

        specs.Code.AppendBhvFile = 0;
        
        if exist('InterCode'),
            InterCode;
        end

        OptsTryUpdate;

        PreTrialStats;

        InitTrial;
        PreTrialCache;

        PreTrialFiles;

        PreTrialFigures(TrialHeader);
        
        TriggersCondition;

        % ITI Finish
        WaitSecs((opts.Timing.ITITime-(GetSecs-cache.trial.Timing.OriginalStartTime)*1000)/1000);

        TrialStagesExecute;
        
    catch ME,
        
        err_msg = sprintf('Session Ended with Error:\n%s\n\n',ME.message)
        for i = 1:length(ME.stack),
            err_msg = [err_msg sprintf('\t\t%s (line %d)\n', ME.stack(i).name, ME.stack(i).line)];
        end

        try,
            specs.Version.SaveFileName = specs.Version.DumpFileName;
            TerminateSave;
        end
        MailAdd(err_msg,NaN,'h');
        try,
            TerminateMail;
        end
        MailSend;
        
        try,
            TerminateRecording;
        end
        
        keyboard;
        
        rethrow(ME);
        
    end
    
end


%% Finish
stats.EndTime = GetSecs;


%% save
TerminateSave;


%% Mail
TerminateMail;
MailSend;


%% Stop recording and clear
TerminateRecording;


%% Output
if ~nargout,
    fprintf('No output from RunSession function. Ensure successful filesave\n');
elseif nargout == 1,
    varargout{1} = struct('specs', specs, 'devs', devs, ...
        'opts', opts, 'funcOpts', funcOpts, 'optsHistory', optsHistory, ...
        'stats', stats, 'files', files, ...
        'trials', trials, 'eyes', eyes, 'cache', cache, 'figures', figures);
else,
    output = {specs devs opts funcOpts optsHistory stats files trials eyes cache figures};
    for i=1:length(output),
        varargout{i} = output{i};
    end
end