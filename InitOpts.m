function InitOpts( varargin )
% Sets option defaults for a specific task. Opts is the set of parameters
% that the user can change at any time during a session and the values
% should affect the flow of the session
% You can pass arguments through the varargin. But field has to be a cell
% of strings making up the field path and second value has to be a string.
% e.g. SetOptions_Chunking({'Timing' 'DelayTime'},'[400 800]');

%%
global specs opts

%% Eye fixation
%%%%%%%%%
opts.Tracking.FixInitFusionAlpha = .75;
opts.Tracking.FixInitFusionWindow = 10;
opts.Tracking.MeanFixWeights = 's';



%% Behavior
%%%%%%%%%
opts.Behavior.StopConditionAttempted = [1 -5 -6 -7 -8];
opts.Behavior.StopConditionCorrect = [1 -5 -8];
opts.Behavior.StopConditionIncorrect = [-6 -7];
opts.Behavior.StopConditionIdle = [-2 -4];
opts.Behavior.StopConditionBroken = [-3];
opts.Behavior.IdleTrialsWindow = 2;
opts.Behavior.ActionList = {'FixAcq' 'FixHold' 'BarAcq' 'BarHold'};
opts.Behavior.FixAcq = [struct('Stage','FIX_ON','Boolean',1,'Radius',2/180*pi)];
holdradius = [2.9; 3.3]; %%% pk
opts.Behavior.FixHold = [struct('Stage','FIX_ON','Boolean',1,'Radius',holdradius/180*pi) ...
                         struct('Stage','CUE_ON','Boolean',1,'Radius',holdradius/180*pi) ...
                         struct('Stage','SAMPLE_ON','Boolean',1,'Radius',holdradius/180*pi) ...
                         struct('Stage','MASK_ON','Boolean',1,'Radius',holdradius/180*pi) ...
                         struct('Stage','DELAY_ON','Boolean',1,'Radius',holdradius/180*pi) ...
                         struct('Stage','FEEDBACK_ON','Boolean',1,'Radius',holdradius/180*pi)];
opts.Behavior.BarAcq = [struct('Stage','FIX_ON','Boolean',1)];
opts.Behavior.BarHold = [struct('Stage','FIX_ON','Boolean',1) ...
                         struct('Stage','CUE_ON','Boolean',1) ...
                         struct('Stage','SAMPLE_ON','Boolean',1) ...
                         struct('Stage','MASK_ON','Boolean',1) ...
                         struct('Stage','DELAY_ON','Boolean',1) ...
                         struct('Stage','FEEDBACK_ON','Boolean',1)];



%% Timing
%%%%%%%%%
opts.Timing.ITITime = 800; % in ms %%% pk

opts.Timing.MaxInitiateTrialTime = 15; %in sec
opts.Timing.MaxAcquireFixTime = 3000; %in ms
opts.Timing.MaxAcquireBarTime = 2000; %in ms
opts.Timing.FixGraceTime = 300; %in ms
opts.Timing.FixTime = 650; %in ms
opts.Timing.CueTime = 370; %in ms
opts.Timing.CueMaskTime = 0; %in ms
opts.Timing.CueDelayTime = 550; %in ms
opts.Timing.StimTime = 370; %in ms
opts.Timing.StimMaskTime = 0; %in ms
opts.Timing.StimDelayTime = 550; %in ms
opts.Timing.FeedbackDisplayTime = 0; %in ms
opts.Timing.CutoffSigmoidSlope = 500;
opts.Timing.LowerCutoffSigmoidMean = .010; %in s
opts.Timing.UpperCutoffSigmoidMean = 1.700; %in s

opts.Timing.Timeout.Policy = 'stop_condition'; %{'stop_condition', 'uniform', 'adaptive'}
opts.Timing.Timeout.StopCondition = [0 1 -2 -3 -4 -5 -6 -7 -8];
opts.Timing.Timeout.Duration = [0 0 500 2000 1000 500 1000 1000 500]; %in ms
opts.Timing.Timeout.Variability = [0 0]; %in ms

opts.Timing.Timeout.IncScale = .6;
opts.Timing.Timeout.BreakScale = 1;



%% Reward
%%%%%%%%%
opts.Reward.Baseline = 0;

opts.Reward.StopCondition = [1 -2 -3 -5 -8];
opts.Reward.ProbabilityReward = [1 0 0 .4 .4];
opts.Reward.StopConditionBonus =[0 -2 -1 1 1];

opts.Reward.StopConditionList = [1 -3 -5 -6 -7 -8];

opts.Reward.StopConditionWeight = [1 0 .5 0 0 .5];
opts.Reward.Tiers = [-1/20 12/20 13/20 14/20 15/20 16/20 17/20 18/20 19/20 20/20];
opts.Reward.TierBonus = [0 0 0 0 0 0 0 0 0 0];
opts.Reward.History = 20;
opts.Reward.RandomSample = 20;

opts.Reward.StopConditionCorrect = [1];
opts.Reward.IncrementSize = 0; %%% pk
opts.Reward.IncrementStep = 450; %%% 330
opts.Reward.NumCorrectJumpstart = 0;

opts.Reward.JackpotChance = 0.001;
opts.Reward.Jackpot = 20;

opts.Reward.Pulse = 60; %%% pk 65; %in ms
opts.Reward.InterRewardDelay = 160; %in ms



%% Display
%%%%%%%%%
opts.Display.ScreenDist = 61; %in cm

opts.Display.BackgroundColor = [0.16 0.16 0.16];
opts.Display.FrameColor = [0.16 0.16 0.16]; %[0.65 0.65 0.65];
opts.Display.FrameRect = 4.5/180*pi;
opts.Display.FrameEdge = 4.5/180*pi;%nm hdh
opts.Display.DisplayOffset = [0 0]/180*pi;
opts.Display.FixLocation = [0 0]/180*pi;
opts.Display.FixRadius = 0.15/180*pi; %dva (in radians)
opts.Display.FixColor = [.75 .75 .75];
opts.Display.CueLocation = [0 0]/180*pi;
opts.Display.CueEdge = 4.4/180*pi;
opts.Display.StimLocation = [0 0]/180*pi;
opts.Display.StimEdge = 4.4/180*pi;

opts.Display.TimeoutBackground.StopCondition = [0 1 -2 -3 -4 -5 -6 -7 -8]; %%% detect nonlisted sc and use 0 value
opts.Display.TimeoutBackground.Color = 0.6*[[.50 .50 .50]; [.40 .40 .40]; [.40 .40 .40]; [.03 .40 .79]; [.40 .40 .40]; [.04 .46 .09]; [.77 .29 .29]; [.77 .29 .29]; [.04 .46 .09]];

opts.Display.Eyelink.FixPointRadius = 2;

opts.Display.FeedbackColor = [[.9 .82 .05]; [.03 .45 .85]];
opts.Display.FeedbackIndex = [1 0];
opts.Display.PeripheralEdge = 3.9/180*pi;

opts.Display.Photon.Color = [1 1 1];
opts.Display.Photon.Edge = [65 65];
opts.Display.Photon.RectPerc = [0.0 1.0]; %percent screen distance from left-top corners of screen




%% Task and sequencing
%%%%%%%%%
opts.Task.NullStimUse = 1;
opts.Task.NullStimProbPenalty = .25; %%% pk
opts.Task.ShowFirstSample = 0;
opts.Task.ShowSecondSample = 0;
opts.Task.ShowCheat = 0;
opts.Task.ShowFeedback = 0;
opts.Task.ShowMasks = 0;
opts.Task.DelayRewardProb = 0;
opts.Task.DelayRewardDrops = 0;



%% Conditions
%%%%%%%%%   
opts.Conditions.Policy = 'random'; %{'random', 'biased_random', 'probabilistic'}; %%% pk
opts.Conditions.History = 20;
opts.Conditions.HistoryWindow = 250;
opts.Conditions.BiasedRandom.Ratio = 1/4;
opts.Conditions.BiasedRandom.StopConditionList = [1 -5 -6 -7 -8];
opts.Conditions.BiasedRandom.StopConditionCorrect = [1 -5 -8];
opts.Conditions.BiasedRandom.MinimumTrials = 10;
opts.Conditions.RepeatErrors.StopConditionList = [-6 -3];
opts.Conditions.RepeatErrors.ProbabilityOfRepeat = [.1 .1];
opts.Conditions.RepeatErrors.MaxRepeats = [3 3];

opts.Conditions.ConditionBias.Control = 0; %%% pk
opts.Conditions.ConditionBias.Ratio = 1; %1/1.5; %%% pk
opts.Conditions.ConditionBias.StopConditionList = [1 -3 -5 -6 -7 -8];
opts.Conditions.ConditionBias.StopConditionCorrect = [1 -5 -6 -7 -8];
opts.Conditions.ConditionBias.MinimumTrials = 5;
opts.Conditions.ConditionBias.History = 20;
opts.Conditions.ConditionBias.HistoryWindow = 250;
opts.Conditions.ConditionBias.Function = 'l'; % softmax, linear
opts.Conditions.ConditionBias.SoftmaxAlpha = 8;

InitMetaCondition;

opts.Conditions.Block.MetaConditionProbList = ProbabilityVector(ones(1,8)); %%% pk
% opts.Conditions.Block.MetaConditionProbList = ProbabilityVector(reshape(repmat([.75 1 1 1.5 1.5 1.5 1.75 1.75 1.75 1.25 1.25 1],8,1),1,[]));
opts.Conditions.Block.ChangePolicy = 'criterion'; %{'size', 'criterion'}
opts.Conditions.Block.NextBlockPolicy = 'permutation'; %{'permutation', 'sequence', 'block_bias'};
opts.Conditions.Block.Size = repmat([1500 1500],size(opts.Conditions.Block.MetaConditionProbList,1),1);
opts.Conditions.Block.Bias = repmat(1,1,size(opts.Conditions.Block.MetaConditionProbList,1));
opts.Conditions.Block.Criterion.Threshold = [1];
opts.Conditions.Block.Criterion.History = 40;
opts.Conditions.Block.Criterion.MinimumTrials = 25;
opts.Conditions.Block.Criterion.StopConditionList = [1 -5 -6 -7 -8];
opts.Conditions.Block.Criterion.StopConditionCorrect = [1 -5 -8];



%% Code housekeeping
%%%%%%%%%
opts.Code.UpdateTimeStamp = clock;
opts.Code.SaveCodeFile = 0;
opts.Code.UseKb = 0;
opts.Code.MailSend = 1;
opts.Code.TerminateConditions = strcat('false'); %%% pk
% opts.Code.TerminateConditions = strcat('false |', ...
%                                        'stats.TrialNo >= 1000 |', ...
%                                        ' stats.RunningTime - stats.IdleTime >= 145 |', ...
%                                        ' stats.CorrectTrials >= 470 |', ...
%                                        ' stats.RunningTime >= 155');



%% varargin
%%%%%%%%%
if mod(length(varargin), 2) ~= 0, error('\nError(InitOptions): Must pass key/value pairs\n'); end
for i = 1:2:length(varargin),
    fields = varargin{i};
    if iscell(fields),
        nfields = length(fields);
        str = 'opts';
        for j = 1:nfields, str = strcat(str,['.(' ''''],fields{j},['''' ')']); end
        try, eval(sprintf('%s = %s;',str,varargin{i+1})); end
    end
end