function PostTrialReward

%%% Task - general

%%
global specs devs opts cache

cache.trial.Reward.NumRewards = RewardCalculate;
RewardDeliver(specs.ParallelPort.Address,specs.ParallelPort.RewardBit,devs.ioObj,cache.trial.Reward.NumRewards,opts.Reward.Pulse,opts.Reward.InterRewardDelay);